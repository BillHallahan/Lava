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
	return (x_0 + 10) + "";
}

function beforeAfter(x_0)
{
	return 'B' + x_0 + 'A';
}

function f952f(x_0, x_1, x_2)
{
	return beforeAfter(toStr(x_1));
}

function f972f(x_0, x_1, x_2)
{
	return beforeAfter(x_1);
}

function f305f(x_0, x_1)
{
	return concat(beforeAfter(x_0), beforeAfter(x_0));
}

function f639f(x_0, x_1, x_2)
{
	return len(f305f(x_0, x_1));
}

function f927f(x_0, x_1)
{
	return f639f(x_0, add(x_1, x_1), f305f(x_0, x_1));
}

function f290f(x_0, x_1, x_2)
{
	return f639f(x_2, f639f(x_0, x_1, x_2), f952f(x_1, x_1, x_1));
}

//@pbe (constraint (= (f825f "xyz" 2 3) "20"))
//@pbe (constraint (= (f825f "xyz" -4 6) "20"))
//@pbe (constraint (= (f825f "ab cd" 6 3) "24"))