package atriumFloorPlay
{

	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.b2Body;

	public class PhysicsBody
	{
		private var _body:b2Body;
		private var _joint:b2MouseJoint;

		public function PhysicsBody(body:b2Body, joint:b2MouseJoint)
		{
			_body = body;
			_joint = joint;
		}

		public function get body():b2Body
		{
			return _body;
		}

		public function get joint():b2MouseJoint
		{
			return _joint;
		}
	}
}
