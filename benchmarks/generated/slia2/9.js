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

function increment(x_0)
{
	return x_0 + 1;
}

function len(x_0)
{
	return x_0.length;
}

function toStr(x_0)
{
	return x_0 + "";
}

function appendNum(x_0, x_1)
{
	return x_1 + x_0;
}

function rptStr(x_0, x_1)
{
	if(x_1 <= 5) { return x_0.repeat(x_1); } else { return x_0.repeat(5); }
}

function f69f(x_0, x_1)
{
	return mult(x_1, x_0);
}

function f41f(x_0, x_1)
{
	return mult(mult(x_0, x_0), add(x_0, x_0));
}

function f50f(x_0, x_1, x_2)
{
	return rptStr(rptStr(x_0, x_2), increment(x_2));
}

function f10f(x_0, x_1, x_2)
{
	return add(len(x_0), f41f(x_1, x_0));
}

function f16f(x_0, x_1, x_2)
{
	return toStr(f69f(x_1, x_1));
}

function f21f(x_0, x_1)
{
	return f10f(x_1, len(x_0), len(x_0));
}

function f65f(x_0, x_1)
{
	return f21f(toStr(x_1), f50f(x_0, x_1, x_1));
}

function f22f(x_0, x_1)
{
	return increment(f69f(x_1, x_1));
}

function f24f(x_0, x_1)
{
	return toStr(f69f(x_0, x_0));
}

//@pbe (constraint (= (f53f "asdf" 5 7) 216))
//@pbe (constraint (= (f53f "hello world" 2 0) 2))
//@pbe (constraint (= (f53f "hi" 7 7) 116))