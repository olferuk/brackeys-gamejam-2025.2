shader_type canvas_item;

uniform float speed = 1.2;

void vertex() {
	UV.x -= speed / 2.0 * TIME;
	UV.y -= speed / 1.2 * TIME;
}
