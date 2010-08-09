package org.tinytlf.interaction.gestures.keyboard.arrows
{
	import flash.events.KeyboardEvent;
	
	import org.tinytlf.util.FTEUtil;
	
	[Event("keyDown")]
	
	public class LeftArrowCtrlGesture extends LeftArrowGesture
	{
		override public function left(event:KeyboardEvent):Boolean
		{
			return super.left(event) && FTEUtil.isMac() ? event.altKey : event.ctrlKey;
		}
	}
}