package error;

class AssertError
{
	public var message:String;

	public function new(?message:String, ?info:haxe.PosInfos)
	{
		this.message = message;

		var stack = haxe.CallStack.toString(haxe.CallStack.callStack());
		stack = ~/\nCalled from error\.AssertError."$/m.replace(stack, "");

		var s = (message == null ? "" : "\"" + message + "\"");
		throw 'Assertion $s failed in file ${info.fileName}, line ${info.lineNumber}, ${info.className}:: ${info.methodName}\nCall stack:${stack}';
	}

	public function toString():String return message;
}