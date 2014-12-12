/* @pjs preload="gradient.jpg"; */

HCanvas canvas;
HDrawablePool pool;
HColorPool colors;

void setup() {
size(640,640,P3D);

	H.init(this).background(#000000).autoClear(true).use3D(true);
	smooth();

    colors = new HColorPool()
        .add(#08756A)
        .add(#509921)
        .add(#CBC934)
        .add(#1B68F5)
        .add(#37A0F3)
        .add(#6C0F07)
        .add(#D22F12)
        .add(#FD8200)
        .add(#DE4084)
        .add(#DB77A7)
        .add(#8B2E99)
    ;

	canvas = new HCanvas(P3D).autoClear(true);
	H.add(canvas);

	pool = new HDrawablePool(1000);
    pool.autoAddToStage()
		.add(
			new HShape("umbrella.svg")
		)
		.onCreate(
			new HCallback() {
				public void run(Object obj) {
					int i = pool.currentIndex();

					HShape d = (HShape) obj;
					d
						.noStroke()
						.size( (int)random(40,80) , (int)random(60,80) )
						.loc(  (int)random(width), (int)random(height) )
						.anchorAt(H.CENTER);

                    d.randomColors(colors);

                    d
						.obj("xo", new HOscillator()
							.target(d)
							.property(H.X)
							.relativeVal(d.x())
							.range( -(int)random(5,10) , (int)random(5,10) )
							.speed( random(.005,.2) )
							.freq(10)
							.currentStep(i)
						)

						.obj("ao", new HOscillator()
							.target(d)
							.property(H.ALPHA)
							.range(50,255)
							.speed( random(.3,.9) )
							.freq(5)
							.currentStep(i)
						)

						.obj("wo", new HOscillator()
							.target(d)
							.property(H.WIDTH)
							.range(-d.width(),d.width())
							.speed( random(.05,.2) )
							.freq(10)
							.currentStep(i)
						)

						.obj("ro", new HOscillator()
							.target(d)
							.property(H.ROTATION)
							.range(-180,180)
							.speed( random(.005,.05) )
							.freq(10)
							.currentStep(i)
						)

						.obj("zo", new HOscillator()
							.target(d)
							.property(H.Z)
							.range( -400 , 400 )
							.speed( random(.005,.01) )
							.freq(15)
							.currentStep(i*5)
						)
					;
				}
			}
		)

		.onRequest(
			new HCallback() {
				public void run(Object obj) {
					HDrawable d = (HDrawable) obj;
					d.scale(1).alpha(0).loc((int)random(width),(int)random(height),-(int)random(200));

					HOscillator xo = (HOscillator) d.obj("xo"); xo.register();
					HOscillator ao = (HOscillator) d.obj("ao"); ao.register();
					HOscillator wo = (HOscillator) d.obj("wo"); wo.register();
					HOscillator ro = (HOscillator) d.obj("ro"); ro.register();
					HOscillator zo = (HOscillator) d.obj("zo"); zo.register();
				}
			}
		)

		.onRelease(
			new HCallback() {
				public void run(Object obj) {
					HDrawable d = (HDrawable) obj;

					HOscillator xo = (HOscillator) d.obj("xo"); xo.unregister();
					HOscillator ao = (HOscillator) d.obj("ao"); ao.unregister();
					HOscillator wo = (HOscillator) d.obj("wo"); wo.unregister();
					HOscillator ro = (HOscillator) d.obj("ro"); ro.unregister();
					HOscillator zo = (HOscillator) d.obj("zo"); zo.unregister();
				}
			}
		)
	;
  
	new HTimer(50)
		.callback(
			new HCallback() {
				public void run(Object obj) {
					pool.request();
				}
			}
		)
	;
}

void draw() {
  for(HDrawable d : pool) {
		d.loc( d.x(), d.y() - random(0.25,1), d.z() );

		d.noStroke();

		// if the z axis hits this range, change fill to light yellow
		if (d.z() > -10 && d.z() < 10){
			d.fill(#FFFFCC);
		}

		if (d.y() < -40) {
			pool.release(d);
		}
	}

	H.drawStage();
}

