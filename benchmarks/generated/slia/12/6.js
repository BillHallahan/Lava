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

function f272f(x_0, x_1, x_2)
{
	return add(x_0, add(x_0, x_0));
}

function f58f(x_0, x_1)
{
	return beforeAfter(x_0);
}

function f604f(x_0, x_1, x_2)
{
	return add(add(x_1, x_2), mult(x_1, x_2));
}

function f757f(x_0, x_1)
{
	return toStr(x_0);
}

function f474f(x_0, x_1)
{
	return concat(x_1, concat(x_1, x_1));
}

function f988f(x_0, x_1, x_2)
{
	return len(x_0);
}

//@pbe (constraint (= (f466f "xyz" "hello world" "vvvvv") "3"))
//@pbe (constraint (= (f466f "ab cd" "xyz" "vvvvv") "5"))
//@pbe (constraint (= (f466f "hello world" "mno pqr st" "xyz") "11"))
//@pbe (constraint (= (f466f "mno pqr st" "xyz" "mno pqr st") "10"))