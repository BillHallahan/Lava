#!/usr/bin/env python3

import os
import sys
import subprocess
from random import randint, choice
from math import floor, ceil

# List of currently used function ids (cannot repeat ids, to avoid namespace conflicts)
idnums = []

# Class for a callable JavaScript function
class JSFunction:

    # Initialize new JS function
    # id: string
    # in: [int] -> list of input types
    # out: int -> output type (0 for integer type, 1 for string type)
    # body: string -> JS function body
    def __init__(self, id, in_type, out_type, body):
        self.id = id
        self.t_in = in_type
        self.t_out = out_type
        self.body = body

    # String representation of this function
    def __repr__(self):
        args = ", ".join(["x_{}".format(i) for i in range(self.arity())])
        return "function {}({})\n{{\n\t{}\n}}".format(self.id, args, self.body)

    # asdf
    def arity(self):
        return len(self.t_in)

    # asdf
    def call(self, arg_strings):

        # Validate number of arguments
        if len(arg_strings) != self.arity():
            exit("error: wrong number of arguments to generate call expression")

        # 0-arity functions just return their names
        if arg_strings:
            return "{}({})".format(self.id, ", ".join(arg_strings))
        else:
            return self.id

    # asdf
    def generate(self, grammar, depth):

        # If depth is zero, reduce the grammar to only atoms
        if not depth:
            grammar = [g for g in grammar if g.arity() == 0]

        # asdf
        arg_strings = []
        for t in self.t_in:

            # filter to type
            filtered = [f for f in grammar if f.t_out == t]
            if not filtered:
                return None

            # asdf
            root = choice(filtered)
            result = root.generate(grammar, depth - 1)
            if result:
                arg_strings.append(result)
            else:
                return None

        # asdf
        return self.call(arg_strings)

    # call function and get results
    # fs: [JSFunction] -> all functions that need to be defined in the file in order to call the target
    # args: [int OR string] -> arguments to call the function with
    def invoke(self, fs, args):

        # Write definitions and invocation to file
        defs = "\n".join([str(f) for f in fs + [self]])
        invocation = self.call(args)
        with open('TEMPFILE.js', 'w') as file:
            file.write('{}\nconsole.log({});'.format(defs, invocation))

        # Run the file, parse the output
        output = subprocess.check_output(["node", "TEMPFILE.js"]).decode().rstrip('\n')
        os.remove('TEMPFILE.js')

        # Format as string if output type is string
        if self.t_out == 1:
            output = '"{}"'.format(output)
        return output

    # asdf
    def fuzzPBE(self, fs, n):

        # Fuzzing methods
        fuzzInt = lambda: str(randint(0, 10))
        fuzzStr = lambda: choice(['"asdf"', '"hello world"', '"404"', '"ab cd"', '"xyz"', '"vvvvv"', '"mno pqr st"'])

        # fuzz each example
        pbe_exs = []
        out_vals = []
        for _ in range(n):

            # randomize inputs, invoke for output
            inputs = [fuzzInt() if t == 0 else fuzzStr() for t in self.t_in]
            output = self.invoke(fs, inputs)
            out_vals.append(output)

            # format as example and add to list
            ex = "//@pbe (constraint (= ({} {}) {}))".format(self.id, ' '.join(inputs), output)
            pbe_exs.append(ex)

        # return list
        return pbe_exs, out_vals

# generate a new function which is a composition of some members of all_funcs
# all_funcs: [JSFunction] -> list of options to compose from
def topLevelGenerate(funcs, depth, types):
    global idnums

    # Random arity
    arit = randint(1, 3)
    atoms = [JSFunction("x_" + str(i), [], choice(types), "") for i in range(arit)]
    grammar = atoms + funcs

    # Random id for the new function
    idn = 0
    while idn in idnums:
        idn = str(randint(0, 1000))
    idnums.append(idn)

    # Recursively generate the new function
    root = choice(funcs)
    result = root.generate(grammar, depth - 1)

    # asdf
    if not result:
        return None
    else:
        body = 'return {};'.format(result)
        return JSFunction('f' + str(idn) + 'f', [a.t_out for a in atoms], root.t_out, body)

# load a collection of primitive JS functions from a .js file
# file: string -> .js file to load from
def loadPrimitives(filename):

    # read lines into list
    with open(filename) as f:
        contents = f.readlines()

    # iterate over lines looking for primitives
    primitives = []
    for i in range(len(contents)):

        # look for type annotations
        line = contents[i]
        if line.startswith("// @type: "):

            # get info about the function
            type = [int(t) for t in line[10:-1]]
            fid = contents[i+1].split(' ')[1]
            fid = fid[:fid.index('(')]
            body = contents[i+2].strip()

            # create and append new function
            new_func = JSFunction(fid, type[:-1], type[-1], body)
            primitives.append(new_func)

    # return full list when finished
    return primitives

# Randomly generate JS functions that are compositions of a list of provided primitives,
# and format generated functions as synthesis problems over the primitives by fuzzing each function
# and writing the inputs and outputs as pbe examples, along with the primitive definitions, to a file
def main():

    # Arg validation
    if len(sys.argv) != 3:
        exit("usage: ./Generator.py generations files_per_gen")
    try:
        generations = int(sys.argv[1])
        files_per_gen = int(sys.argv[2])
    except:
        exit("error: arguments must be an integers")

    # Constants
    depth = 2
    path = "benchmarks/generated"
    logics = ["lia", "strings", "slia"]

    # Generate a list of functions composed from the provided primitives
    for logic in logics:
        primitives_file = "{}/JSprimitives/{}.js".format(path, logic)
        primitives = loadPrimitives(primitives_file)
        for g in range(generations):

            i = 0
            funcs = list(primitives)
            while i < files_per_gen:

                # Generation may fail
                types = [0] if logic == "lia" else [1] if logic == "strings" else [0, 1]
                new_func = topLevelGenerate(funcs, depth, types)
                if not new_func:
                    continue

                # Make sure we didnt generate a trivial function
                _, outputs = new_func.fuzzPBE(funcs, 10)
                if outputs.count(outputs[0]) == len(outputs):
                    continue

                # Add function to list
                funcs.append(new_func)
                i += 1

            # Create synthesis problems
            filenum = 0
            dest_dir = "{}/{}/{}".format(path, logic, str(g))
            for j in range(len(primitives), len(funcs)):

                # Get pbe examples by invoking the function repeatedly
                fs = funcs[:j]
                f = funcs[j]
                pbe_exs, _ = f.fuzzPBE(fs, randint(2, 5))

                # Write definitions and pbe examples to benchmark file
                defs = "\n\n".join([str(fdef) for fdef in fs])
                with open('{}/{}.js'.format(dest_dir, str(filenum)), 'w') as file:
                    file.write(defs + '\n\n' + '\n'.join(pbe_exs))
                filenum += 1

# Entry point
if __name__ == "__main__":
    main()
