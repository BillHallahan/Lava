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

function f212f(x_0, x_1)
{
	return concat(beforeAfter(x_0), len(x_1));
}

function f432f(x_0, x_1)
{
	return len(f212f(x_1, x_0));
}

//@pbe (constraint (= (f177f "mno pqr st" "mno pqr st" "xyz") "14"))
//@pbe (constraint (= (f177f "vvvvv" "404" "mno pqr st") "6"))
//@pbe (constraint (= (f177f "hello world" "xyz" "404") "7"))