function add(x_0, x_1)
{
	return x_0 + x_1;
}

function mult(x_0, x_1)
{
	return x_0 * x_1;
}

function increment(x_0)
{
	return x_0 + 1;
}

function decrement(x_0)
{
	return x_0 - 1;
}

function subtract(x_0, x_1)
{
	return x_0 - x_1;
}

function double(x_0)
{
	return x_0 * 2;
}

function f713f(x_0, x_1, x_2)
{
	return add(x_1, x_2);
}

function f120f(x_0, x_1)
{
	return double(x_1);
}

function f367f(x_0, x_1, x_2)
{
	return f120f(increment(x_1), f713f(x_2, x_1, x_1));
}

function f614f(x_0, x_1, x_2)
{
	return f713f(x_1, decrement(x_0), increment(x_0));
}

function f279f(x_0, x_1, x_2)
{
	return f367f(x_1, f614f(x_1, x_1, x_0), f614f(x_2, x_0, x_2));
}

function f129f(x_0, x_1)
{
	return f367f(increment(x_1), x_0, increment(x_0));
}

//@pbe (constraint (= (f55f 1) 4))
//@pbe (constraint (= (f55f -2) 16))
//@pbe (constraint (= (f55f -5) 100))