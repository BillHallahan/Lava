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

function f728f(x_0, x_1, x_2)
{
	return add(len(x_0), add(x_2, x_2));
}

function f803f(x_0, x_1)
{
	return f728f(beforeAfter(x_0), concat(x_0, x_0), x_1);
}

function f270f(x_0, x_1)
{
	return mult(add(x_0, x_0), x_0);
}

function f248f(x_0, x_1)
{
	return len(toStr(x_0));
}

function f41f(x_0, x_1, x_2)
{
	return beforeAfter(toStr(x_0));
}

function f220f(x_0, x_1)
{
	return mult(mult(x_1, x_1), f728f(x_0, x_0, x_1));
}

//@pbe (constraint (= (f244f 8 "ab cd") "23"))
//@pbe (constraint (= (f244f 1 "vvvvv") "9"))