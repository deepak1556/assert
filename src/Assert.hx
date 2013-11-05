package error;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class Assert
{
	macro public static function assert(predicate:Expr, ?info:Expr):Expr
	{
		if (!Context.defined("debug")) return macro {};

		var error = false;
		switch (Context.typeof(predicate))
		{
			case TAbstract(_, _):
			case _: error = true;
		}

		if (error) Context.error("predicate should be a boolean", predicate.pos);
		
		switch (Context.typeof(info))
		{
			case TMono(t):
			     error = t.get() != null;
			case TInst(t, _):
			     error = t.get().name != "String";
			case _" error = true;
		}

		if (error) Context.error("info should be a string", info.pos);

		var p = Context.currentPos();
		var econd = {expr: EBinop(OpNotEq, {expr: Econst(Cident("true")), pos: p}, predicate), pos: p};
		var eif = {expr: EThrow({expr: ENew({name: "AssertError", pack: ["error"], params: []}, [info]), pos: p }), pos: p};

		return {expr: EIf(econd, eif, null), pos: p};
	}
}