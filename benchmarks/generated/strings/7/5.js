function concat(x_0, x_1)
{
	return x_0 + x_1;
}

function len(x_0)
{
	return x_0.length + "";
}

function beforeAfter(x_0)
{
	return 'B' + x_0 + 'A';
}

function lastLetter(x_0)
{
	if (x_0.length > 0) { return x_0.slice(-1); } else { return ''; }
}

function firstWord(x_0)
{
	return x_0.substring(0, x_0.indexOf(" "));
}

function rep(x_0, x_1, x_2)
{
	return x_0.replace(x_1, x_2);
}

function f993f(x_0, x_1, x_2)
{
	return rep(beforeAfter(x_1), firstWord(x_1), x_2);
}

function f138f(x_0, x_1)
{
	return f993f(f993f(x_1, x_0, x_1), rep(x_1, x_1, x_1), f993f(x_1, x_0, x_0));
}

function f494f(x_0, x_1, x_2)
{
	return concat(x_1, x_2);
}

function f290f(x_0)
{
	return len(f138f(x_0, x_0));
}

function f254f(x_0, x_1, x_2)
{
	return lastLetter(concat(x_2, x_1));
}

//@pbe (constraint (= (f181f "vvvvv") "vvvvvBvvvvvABvvvvvA"))
//@pbe (constraint (= (f181f "vvvvv") "vvvvvBvvvvvABvvvvvA"))
//@pbe (constraint (= (f181f "404") "404B404AB404A"))