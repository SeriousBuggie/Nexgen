/***************************************************************************************************
 *
 *  NSC. Nexgen Server Controller by Zeropoint.
 *
 *  $CLASS        NexgenHSliderControl
 *  $VERSION      1.00 (03-05-2020 15:30)
 *  $AUTHOR       Patrick 'Sp0ngeb0b' Peltzer
 *  $CONTACT      spongebobut@yahoo.com
 *  $DESCRIPTION  Nexgen extended H Slider component class.
 *
 **************************************************************************************************/
class NexgenHSliderControl extends UWindowHSliderControl;

var int dist;


/***************************************************************************************************
 *
 *  $DESCRIPTION  Prepares the window for the paint call.
 *  $PARAM        c  The canvas object which acts as a drawing surface for the dialog.
 *  $PARAM        x  Mouse x coordinate.
 *  $PARAM        y  Mouse y coordinate.
 *  $OVERRIDE
 *
 **************************************************************************************************/
function beforePaint(Canvas c, float x, float y) {
	local float w, h;
	
	super(UWindowDialogControl).beforePaint(c, x, y);
	
	textSize(c, text, w, h);
	if(h > 0) {
		winHeight = h+1;
		w += dist;
	}
	sliderWidth = winWidth-w;

	switch(align) {
		case TA_Left:
			sliderDrawX = winWidth - sliderWidth;
			textX = 0;
			break;
		case TA_Right:
			sliderDrawX = 0;	
			textX = winWidth - w;
			break;
		case TA_Center:
			sliderDrawX = (winWidth - sliderWidth) / 2;
			textX = (winWidth - w) / 2;
			break;
	}

	sliderDrawY = (winHeight - 2) / 2;
	textY = (winHeight - h) / 2;

	trackStart = sliderDrawX + (sliderWidth - trackWidth) * ((value - minValue)/(maxValue - minValue));
}

defaultproperties
{
}
