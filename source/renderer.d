module renderer;
import std.math;
import std.conv;
import std.stdio;
import std.random;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

import glamour.vao: VAO;
import glamour.shader: Shader;
import glamour.vbo: Buffer;

struct Circle {
	float x, y, radius;
	float[3] color;
};

Circle[] circles = [
	{ 32,  0, 16, [ 1, 0, 0 ] },
	{  0, 32, 16, [ 1, 1, 1 ] },
	{ 32, 32, 16, [ 0, 0, 1 ] },
];

/*
   glVertexAttribPointer(index, size, type, normalized, stride, *offset)
   	boundVAO.attributes[index] = new Attribute(
		buffer_pointer   => boundVBO + offset,
		items_per_vertex => size,
		items_type       => type,
		convert_ints_to_float_range => normalized, // [-1,1] for int, [0,1] for uint
		bytes_between_vertexes      => stride,
	)

   auto shader = new Shader(name, source)
   shader.get_attrib_location(name)
   	shader.get_index_for_named_shader_attr(name)

   shader.get_uniform_
*/

float[] computeCircleVertexes (int n) {
	auto vertexes = new float[n*2];
	for (int i = 0; i < n*2; i += 2) {
		float phi = i * PI / n;
		vertexes[i+0] = cos(phi);
		vertexes[i+1] = sin(phi);
	}
	return vertexes;
}

struct Lens {
	float x, y, width, height;
}

class Shape {
	VAO vao;
	Buffer vbo;
	Shader program;
    GLint  attrPosition;
	int numVertices;
	int anim = 0;

    Lens lens;

	this(const string name, const string program_source, float[] vertices) {
		vbo = new Buffer(vertices);
		vao = new VAO();
		program = new Shader(name, program_source);
		numVertices = to!int(vertices.length);
		// writeln(vertices);

		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_MULTISAMPLE);
		glLineWidth(2);
	}

    void setup() {
		vao.bind();
		vbo.bind();
		program.bind();

		anim++;
		float t = to!float(anim)/2;
		program.uniform2f("lens_offset", lens.x + sin(t)*40, lens.y + cos(t)*40);
		program.uniform2f("lens_scales", lens.width, -lens.height);

		attrPosition = program.get_attrib_location("position");
		glEnableVertexAttribArray(attrPosition);
		glVertexAttribPointer(attrPosition, 2, GL_FLOAT, GL_FALSE, 0, null);
    }
	void render(Circle c) {
		program.uniform2f( "offset", c.x, c.y);
		program.uniform1f( "radius", c.radius);
		program.uniform3fv("color",  c.color);

		// glDrawArrays(GL_TRIANGLE_FAN, 0, numVertices/2);
		glDrawArrays(GL_LINE_LOOP, 0, numVertices/2);
    }
    void teardown() {
		glDisableVertexAttribArray(attrPosition);
		vao.unbind();
		vbo.unbind();
		program.unbind();
	}

	~this() {
		program.remove();
		vbo.remove();
		vao.remove();
	}
}

class Renderer {
	Shape circleShape;
	Lens lens = { 0, 0, 0, 0};

	this() {
		circleShape = new Shape("circle", `
			#version 120
			vertex:
			attribute vec2 position;
			uniform vec2   offset;
			uniform float  radius;
			uniform vec2   lens_offset;
			uniform vec2   lens_scales;
			void main(void) {
				gl_Position = vec4(
					(position * radius + offset - lens_offset) / lens_scales,
					0, 1);
			}
			fragment:
			uniform vec3 color;
			void main(void) {
				gl_FragColor = vec4(color, 1.0);
			}
		`, computeCircleVertexes(10));
	}
	~this() {
		delete circleShape;
	}

	void clear() {
		glClearColor(0, 0, 0, 1);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}

	void render() {
		clear();
		circleShape.lens = lens;
		Circle newCircle = {
			uniform(-lens.width, lens.width), uniform(-lens.height, lens.height), 8,
			[ 0, 1, 0 ]
		};
		circles ~= newCircle;
        circleShape.setup();
		foreach (c; circles) {
			circleShape.render(c);
		}
        circleShape.teardown();
	}
}
