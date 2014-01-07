package com.gamerisker.controls
{
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 *	使用 RadioButton 组件可以强制用户只能从一组选项中选择一项。 
	 *  该组件必须用于至少有两个 RadioButton 实例的组。 
	 *  在任何给定的时刻，都只有一个组成员被选中。 
	 *  选择组中的一个单选按钮将取消选择组内当前选定的单选按钮。 
	 *  您可以设置 group 参数，以指示单选按钮属于哪个组。  
	 * @author YangDan
	 * 
	 */	
	public class RadioButton extends ImageButton
	{
		private var m_data : Object;
		private var m_callfunction : Function;
		private var m_textField : TextField;
		private var m_group : String;
		private var m_RadioButtonGroup : RadioButtonGroup;
		private var m_label : String;
		private var m_isCreateLabel : Boolean = false;

		public function get isCreateLabel():Boolean{return m_isCreateLabel;}
		public function set isCreateLabel(value:Boolean):void{m_isCreateLabel = value;}

		
		public function RadioButton()
		{
			m_width = 100;
			m_height = 20;
			group = "RadioButtonGroup";
		}
		
		override public function Destroy():void
		{
			m_RadioButtonGroup.removeButton(this);
			m_callfunction = null;
			m_RadioButtonGroup = null;
			m_data = null;
			if(m_textField)
			{
				removeChild(m_textField);
				m_textField.dispose();
				m_textField = null;
			}
			super.Destroy();
		}
		
		override protected function draw():void
		{
			const skinInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SKIN);
			const textInvalid : Boolean = isInvalid(INVALIDATION_FLAG_TEXT);
			const sizeInvalid : Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid : Boolean = isInvalid(INVALIDATION_FLAG_STATE);
			
			if(skinInvalid)
			{
				refreshSkin();
			}
			
			if(textInvalid && m_isCreateLabel)
			{
				refreshText();
			}
			
			if(sizeInvalid)
			{
				refreshSize();
			}
			
			if(stateInvalid)
			{
				refreshState();
			}
		}
		
		override protected function refreshState() : void
		{
			if(m_selected && m_background.texture != m_downState)
			{
				m_background.texture = m_downState;
			}
			else if(m_background.texture != m_upState)
			{
				m_background.texture = m_upState;
			}
			
			if(this.touchable != m_enabled)
			{
				this.touchable = m_enabled;
			}
		}
		
		protected function refreshSize() : void
		{
			if(m_textField)
			{
				if(m_textField.width != m_width)
				{
					m_textField.width = m_width;
				}
				
				if(m_textField.height != m_height)
				{
					m_textField.height != m_height;
				}
			}
		}
		
		protected function refreshText() : void
		{
			if(m_label==null)
				return;
			
			if(m_textField==null)
			{
				m_textField = new TextField(m_width,m_height,m_label);
				m_textField.autoSize = TextFieldAutoSize.VERTICAL;
				m_textField.touchable = true;
				addChildAt(m_textField,0);
			}
			
			if(m_textField.text != m_label)
			{
				m_textField.text = m_label;
			}
			m_textField.x = 30;
			m_textField.y = 10;
		}
		
		public function get group():String
		{
			return m_group;
		}
		
		public function set group(value:String):void
		{
			m_group = value;
		}

		public function get label():String{return m_label;}
		public function set label(value:String):void
		{
			m_label = value;
			invalidate(INVALIDATION_FLAG_TEXT);
		}
		
		public function set radioButtonGroup(group : RadioButtonGroup) : void
		{
			m_RadioButtonGroup = group;
		}
		
		/**
		 *	该方法提供给 RadioButtonGroup调用，用来设置按钮属性 
		 * @param fun
		 * 
		 */		
		public function addListener(fun : Function) : void
		{
			m_callfunction = fun;
		}
		
		public function get data():Object
		{
			return m_data;
		}

		public function set data(value:Object):void
		{
			m_data = value;
		}

		override public function get selected():Boolean
		{
			return m_selected;
		}

		override public function set selected(value:Boolean):void
		{
			if(m_selected != value)
			{
				m_selected = value;
				invalidate(INVALIDATION_FLAG_STATE);
			}
		}
		
		override protected function onTouchEvent(event:TouchEvent):void
		{
			var touch : Touch = event.getTouch(this);
			if(!m_selected || touch == null)return;
			
			if(touch.phase == TouchPhase.ENDED&&m_callfunction!=null)
			{
				m_callfunction(this);
			}
		}
	}
}