package org.tinytlf.layout.alignment
{
	import flash.text.engine.*;
	
	import org.tinytlf.layout.*;
	import org.tinytlf.util.*;
	
	public class AlignerBase implements IBlockAligner
	{
		public function getSize(region:TextSector, previousItem:*):Number
		{
			return 0;
		
//			Left, middle, and right alignment
//			var width:Number = layout.width;
//			
//			if(line == null)
//				width -= layout.textIndent;
//			
//			width -= layout.paddingLeft;
//			width -= layout.paddingRight;
//			
//			return width;
		}
		
		public function getStart(region:TextSector, thisItem:*):Number
		{
//			Left alignment
//			var x:Number = layout.paddingLeft;
//			if(line.previousLine == null)
//				x += layout.textIndent;
//			return x;
//			
//			Right alignment
//			return layout.width - line.width - layout.paddingRight;
//			
//			Center alignment
//			return (layout.width - line.width) * 0.5;
			
			return 0;
		}
		
		public function sort(items:Array):Array
		{
			return items.concat();
		}
	}
}