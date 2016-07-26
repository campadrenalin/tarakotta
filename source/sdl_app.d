module sdl_app;

import std.string;
import std.conv;
import std.stdio;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;
import derelict.util.loader;

static import renderer;

class SDLApplication {
	public SDL_Window* sdlwindow;
	auto keep_running = true;
	renderer.Renderer r;

	this(int width, int height, string title) {
		DerelictSDL2.load(SharedLibVersion(2,0,2));
		DerelictGL3.load();

		if (SDL_Init(SDL_INIT_VIDEO) < 0)
			throw new Exception("SDL_Init failed: " ~ to!string(SDL_GetError()));

		 // Set OpenGL version
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);

		// Set OpenGL attributes
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
		SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

		sdlwindow = SDL_CreateWindow(toStringz(title),
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
			width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);

		if (!sdlwindow)
			throw new Exception("Failed to create a SDL window: " ~ to!string(SDL_GetError()));

		SDL_GL_CreateContext(sdlwindow);
		DerelictGL3.reload();

		r = new renderer.Renderer();
	}

	void resize_window(SDL_WindowEvent *we) {
		r.lens.width  = we.data1;
		r.lens.height = we.data2;
		glViewport(0, 0, we.data1, we.data2);
	}

	void handle_window_event(SDL_WindowEvent *we) {
		switch(we.event) {
			case SDL_WINDOWEVENT_RESIZED: resize_window(we); break;
			default: break;
		}
	}

	void handle_event(SDL_Event *event) {
		switch (event.type) {
			case SDL_QUIT:
				keep_running = false; break;
			case SDL_WINDOWEVENT:
				handle_window_event(&event.window); break;
			default: break;
		}
	}

	void handle_events() {
		SDL_Event event;
		while (SDL_PollEvent(&event)) {
			handle_event(&event);
		}
	}

	void on_draw() {
		r.render();
	}

	void run() {
		while (keep_running) {
			handle_events();
			on_draw();
			SDL_GL_SwapWindow(sdlwindow);
		}
		delete r;
	}
}
