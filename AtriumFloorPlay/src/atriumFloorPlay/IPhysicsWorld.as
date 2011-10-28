package atriumFloorPlay
{

	public interface IPhysicsWorld
	{
		function addCursorBody(x:Number, y:Number, radius:Number):PhysicsBody;

		function updateCursorBody(body:PhysicsBody, x:Number, y:Number, radius:Number):void;

		function removeCursorBody(body:PhysicsBody):void;
	}
}
