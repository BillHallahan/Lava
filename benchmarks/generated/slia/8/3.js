function add(x_0, x_1)
{
	return x_0 + x_1;
}

function mult(x_0, x_1)
{
	return x_0 * x_1;
}

function concat(x_0, x_1)
{
	return x_0 + x_1;
}

function len(x_0)
{
	return x_0.length;
}

function toStr(x_0)
{
	return x_0 + "";
}

function beforeAfter(x_0)
{
	return 'B' + x_0 + 'A';
}

function f36f(x_0)
{
	return toStr(x_0);
}

function f759f(x_0, x_1, x_2)
{
	return f36f(mult(x_1, x_1));
}

function f916f(x_0)
{
	return f36f(x_0);
}

//@pbe (constraint (= (f72f "404" 9 "404") "3"))
//@pbe (constraint (= (f72f "vvvvv" 7 "mno pqr st") "5"))
//@pbe (constraint (= (f72f "vvvvv" 6 "asdf") "5"))
//@pbe (constraint (= (f72f "hello world" 4 "vvvvv") "11"))
//@pbe (constraint (= (f72f "ab cd" 10 "404") "5"))