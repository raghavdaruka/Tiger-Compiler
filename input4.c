/* arr1 is valid since expression 0 is int = myint */
let
	type myint = int
	type  arrtype = array of myint

	var arr1:arrtype := arrtype [10] of 0
in
	arr1
end
