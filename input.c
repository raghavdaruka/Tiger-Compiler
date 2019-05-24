let
	var a:=3
	var c:=4
	function add(a:int,b:int):int=a+b
	function abc()=(print("abc");nil)
in
	a:=add(a,c);
	abc();
	print("%d",a)
end

/* a record type and a record variable */
/*let
	type  rectype = {name:string, age:int}
	var rec1:rectype := rectype {name="Nobody", age=1000}
in
	rec1.name := "Somebody";
	rec1
end
*/
/*
let
type a=b


in
	nil;break
end
*/
/*
let

function do_nothing1(a: int, b: string)=
		do_nothing2(a+1)

function do_nothing2(d: int) =
		do_nothing1(d, "str")

in
	do_nothing1(0, "str2")
end
*/