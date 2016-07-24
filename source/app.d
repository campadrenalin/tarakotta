module tarakotta;
import sdl_app;

void main() {
	auto app = new sdl_app.SDLApplication(320,680, "Tarakotta");
	app.r.lens.width  = 320;
	app.r.lens.height = 680;
	app.run();
}
