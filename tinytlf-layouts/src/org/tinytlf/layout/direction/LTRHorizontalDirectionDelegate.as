package org.tinytlf.layout.direction
{
	import flash.text.engine.ContentElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	
	import org.tinytlf.layout.IFlowLayout;
	import org.tinytlf.layout.IFlowLayoutElement;
	import org.tinytlf.layout.descriptions.TextFloat;
	import org.tinytlf.layout.properties.LayoutProperties;
	import org.tinytlf.util.fte.TextLineUtil;
	
	public class LTRHorizontalDirectionDelegate extends DirectionDelegateBase
	{
		public function LTRHorizontalDirectionDelegate(target:IFlowLayout)
		{
			super(target);
		}
		
		override public function prepForTextBlock(block:TextBlock):void
		{
			super.prepForTextBlock(block);
			
			var props:LayoutProperties = getLayoutProperties(block);
			
			layoutPosition.x = 0;
			
			if (block.firstLine == null)
			{
				layoutPosition.x = props.textIndent;
				layoutPosition.y += props.paddingTop;
			}
		}
		
		override public function getLineSize(block:TextBlock, previousLine:TextLine):Number
		{
			return flow(super.getLineSize(block, previousLine), previousLine);
		}
		
		override public function layoutLine(latestLine:TextLine):void
		{
			layoutX(latestLine);
			layoutY(latestLine);
		}
		
		override public function checkTargetConstraints():Boolean
		{
			// This checks for container termination, so respect that first.
			if(super.checkTargetConstraints())
				return true;
			
			if (isNaN(layout.explicitHeight))
				return false;
			
			return layoutPosition.y > layout.explicitHeight;
		}
		
		override public function registerFlowElement(line:TextLine, atomIndex:int):Boolean
		{
			var retVal:Boolean = super.registerFlowElement(line, atomIndex);
			
			var contentElement:ContentElement = TextLineUtil.getElementAtAtomIndex(line, atomIndex);
			if(contentElement.userData is Vector.<*>)
			{
				var element:IFlowLayoutElement = layout.elements.concat().pop();
				var style:Object = layout.engine.styler.describeElement(contentElement.userData);
				var totalWidth:Number = getTotalSize(line.textBlock);
				switch(style.float)
				{
					case TextFloat.LEFT:
						element.x = line.x = 0;
						layoutPosition.x = element.width;
						break;
					case TextFloat.CENTER:
						element.x = line.x = (totalWidth - element.width) * 0.5;
						layoutPosition.x = 0;
						break;
					case TextFloat.RIGHT:
						element.x = line.x = totalWidth - element.width;
						layoutPosition.x = 0;
						break;
				}
			}
			
			return retVal;
		}
		
		protected function flow(totalSize:Number, previousLine:TextLine):Number
		{
			var elements:Vector.<IFlowLayoutElement> = layout.elements;
			var element:IFlowLayoutElement;
			var line:TextLine;
			
			var size:Number = totalSize;
			var n:int = elements.length;
			var i:int = 0;
			
			for(i = 0; i < n; ++i)
			{
				element = elements[i];
				line = element.textLine;
				
				if(line.y >= layoutPosition.y && line.x < layoutPosition.x)
					continue;
				
				if(element.containsY(layoutPosition.y))
				{
					if(layoutPosition.x < element.x)
					{
						size = element.x - layoutPosition.x;
						break;
					}
					else if(layoutPosition.x >= (element.x + element.width))
					{
						size -= element.x;
					}
					else
					{
						size = totalSize - element.x - element.width;
						layoutPosition.x = element.x + element.width;
					}
				}
				
				//If the size ever drops to 0, reset it all and update the y.
				if(size <= 0)
				{
					size = totalSize;
					i = 0;
					layoutPosition.x = 0;
					layoutPosition.y += previousLine.height;
				}
			}
			
			return size;
		}
		
		override protected function layoutX(line:TextLine):void
		{
			line.x = layoutPosition.x;
			layoutPosition.x += line.specifiedWidth;
		}
		
		override protected function layoutY(line:TextLine):void
		{
			var w:Number = getTotalSize(line.textBlock);
			if(layoutPosition.x >= (w - 10))
			{
				layoutPosition.x = 0;
				super.layoutY(line);
			}
			else
			{
				var elements:Vector.<IFlowLayoutElement> = layout.elements;
				var element:IFlowLayoutElement;
				
				var n:int = elements.length;
				
				for(var i:int = 0; i < n; ++i)
				{
					element = elements[i];
					
					if(element.containsY(layoutPosition.y))
					{
						if(layoutPosition.x == element.x)
						{
							line.y = line.ascent + layoutPosition.y;
							break;
						}
					}
					
					if(i == n)
						line.y = layoutPosition.y;
				}
			}
		}
	}
}