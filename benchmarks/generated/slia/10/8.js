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

function f810f(x_0)
{
	return concat(concat(x_0, x_0), x_0);
}

function f257f(x_0, x_1)
{
	return toStr(mult(x_0, x_0));
}

function f833f(x_0, x_1, x_2)
{
	return len(toStr(x_2));
}

function f307f(x_0)
{
	return beforeAfter(toStr(x_0));
}

function f587f(x_0, x_1, x_2)
{
	return f257f(x_1, f810f(x_0));
}

function f530f(x_0, x_1)
{
	return add(f833f(x_0, x_1, x_0), mult(x_0, x_0));
}

function f928f(x_0, x_1, x_2)
{
	return f810f(x_2);
}

function f170f(x_0, x_1, x_2)
{
	return concat(concat(x_2, x_2), f307f(x_0));
}

//@pbe (constraint (= (f867f 3 "404" 0) "404404404404404"))
//@pbe (constraint (= (f867f 7 "ab cd" 7) "ab cdab cdab cdab cdab cd"))
//@pbe (constraint (= (f867f 1 "404" 3) "404404404404404"))