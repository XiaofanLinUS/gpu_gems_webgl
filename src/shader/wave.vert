#version 300 es
#define M_PI 3.1415926535897932384626433832795

precision highp float;

in vec3 position;

uniform mat4 perspective;
uniform mat4 camera;



uniform vec2 D[6];
uniform float A[6];
uniform float w[6];
uniform float phi[6];
uniform float Q[6];

uniform float t; 

out vec3 normal;
out vec3 world;

vec3 get_normal(vec3 p) {
  float final_x = 0.0;
  float final_y = 1.0;
  float final_z = 0.0;


  for(int i = 0; i < 6; i++) {
    float wa = w[i] * A[i];
    float gernst = w[i] * dot(D[i], p.xz) + t * phi[i];
    float c = cos(gernst);
    float s = sin(gernst);
    final_x -= D[i].x * wa * c;
    final_z -= D[i].y * wa * c;
    final_y -= Q[i] * wa * s;
  }

  return vec3(final_x, final_y, final_z);
}
vec3 get_position(vec3 p) {
  float x = p.x;
  float z = p.z;
  float y = 0.0;
  for(int i = 0; i < 6; i++) {
      x += Q[i]* A[i]* D[i].x * cos(w[i]*dot(D[i], p.xz) + phi[i]*t);
      z += Q[i]* A[i]* D[i].y * cos(w[i]*dot(D[i], p.xz) + phi[i]*t);
      y += A[i]*sin(w[i]*dot(D[i], p.xz) + phi[i]*t);
  }

  return vec3(x,y,z);
}
void main() {  
  world = get_position(position);
  normal = normalize(get_normal(vec3(world)));
  gl_Position = perspective * camera * vec4(world, 1.0);
}