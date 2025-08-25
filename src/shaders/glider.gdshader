shader_type canvas_item;

uniform float speed_x = 0.6;
uniform float speed_y = 1.2;

void vertex() {
	UV.x -= speed_x * TIME;
	UV.y -= speed_y * TIME;
}
