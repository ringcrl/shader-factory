/*
        by Uğur Güney. March 8, 2014.
        https://www.shadertoy.com/view/Md23DV
*/

#iChannel0 "file://01-基础/imgs/iChannel0.png"
#iChannel1 "file://01-基础/imgs/iChannel1.png"
#iChannel2 "file://01-基础/imgs/iChannel2.png"

// 通过更改数字来更换教程
#define TUTORIAL 14

/* 教程列表
 1 空白的屏幕
 2 纯色
 3 GLSL 向量
 4 RGB 颜色模型与向量的分量
 5 坐标系统
 6 分辨率，帧画面宽高
 7 坐标转换
 8 水平线和垂直线
 9 可视化坐标系
10 将坐标中心移动到帧画面的中心
11 坐标系宽高比标准化
12 圆盘
13 多个函数
14 内置函数：STEP
15 内置函数：CLAMP
16 内置函数：SMOOTHSTEP
17 内置函数：MIX
18 使用 SMOOTHSTEP 抗锯齿
19 函数示意图
20 颜色加减
21 坐标转换：旋转
22 坐标转换：缩放
23 连续坐标转换
24 时间、动作和动画
25 等离子效果
26 纹理
27 鼠标输入
28 随机
*/

#define PI 3.14159265359
#define TWOPI 6.28318530718

#if TUTORIAL == 1
// 空白的屏幕

// "main" 函数每秒会调用60次，来应用 shader 的效果
// 但是如果 GLSL 脚本有较重的计算，帧率就会下降
// 因为函数中没有做任何事情，所以产生了一块空白的屏幕
void main() {}

#elif TUTORIAL == 2
// 纯色

// "gl_FragColor" 是 shader 的输出变量
// 决定屏幕上一个像素的颜色
// 当前设置所有的像素点的输出颜色都是黄色
void main() { gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0); }

#elif TUTORIAL == 3
// GLSL 向量

// 为 gl_FragColor 分配一个 vec4 向量，该向量由介于 0 和 1 之间的四个分量组成
// 前三个数字确定颜色，第四个数字确定不透明度
// (目前，更改透明度值将无效)
// 一个 vec4 数据结构，可以通过提供4个float来构造，或者1个vec3与1个float来构造
void main() {
  // 分离了代表像素的vec4的颜色和透明度部分
  vec3 color = vec3(0.0, 1.0, 1.0);
  float alpha = 1.0;

  vec4 pixel = vec4(color, alpha);
  gl_FragColor = pixel;
}

#elif TUTORIAL == 4
// RGB 颜色模型与向量的分量
//
// 可以通过"."来获取向量的分量
//
// RGB: http://en.wikipedia.org/wiki/RGB_color_model
// 颜色由三个数字表示（此处为[0.0，1.0]）
// 该模型假定添加了给定强度的纯红色，绿色和蓝色光
//
// 如果缺乏设计技能，并且很难选择漂亮，连贯的颜色，则可以使用这些网站之一来选择调色板，可以在其中浏览不同的颜色集
// https://kuler.adobe.com/create/color-wheel/
// http://www.colourlovers.com/palettes
// http://www.colourlovers.com/colors
void main() {
  float redAmount = 0.6;
  float greenAmount = 0.2;
  float blueAmount = 0.9;

	// vec3(x) 等同于 vec3(x, x, x)
  vec3 color = vec3(0.0);
  
  color.r = redAmount;
  color.g = greenAmount;
  color.b = blueAmount;

  float alpha = 1.0;
  vec4 pixel = vec4(color, alpha);
  gl_FragColor = pixel;
}

#elif TUTORIAL == 5
// 坐标系统

// "gl_FragCoord" 告诉我们屏幕上的像素
// 坐标中心在左下角，坐标值朝右上方向增大

// main 函数针对屏幕上的每个像素点都会执行一次
// 在每次调用时，"gl_FracCoord"具有相应像素的坐标

// GPU有很多核心，可以并行计算不同像素的函数调用
// 这比在CPU上逐个串行计算像素颜色的速度要快
// 但是，它也提出了一个重要的约束条件：
// 一个像素的值不能取决于另一个像素的值
// (计算是并行进行的，因此不可能知道哪一个先于另一完成)
// 像素的结果只能取决于像素坐标（和其他一些输入变量）
// 这是着色器编程的最重要区别
void main() {
  vec3 color1 = vec3(0.886, 0.576, 0.898);
  vec3 color2 = vec3(0.537, 0.741, 0.408);
  vec3 pixel;

  // 如果x坐标大于100，则绘制color1
  // 否则绘制 color2
  float widthOfStrip = 100.0;
  if (gl_FragCoord.x > widthOfStrip) {
    pixel = color2;
  } else {
    pixel = color1;
  }

  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 6
// 分辨率，帧画面宽高

// 如果您调整浏览器的宽度，会看到第一种颜色与第二种颜色的宽度之比随屏幕尺寸而变化
// 这是因为上面的宽度设置为绝对像素数，而不是屏幕宽度和高度的比例

// 假设我们要用不同的颜色绘制左右两半
// 在不知道水平像素数的情况下，确定中点的位置

// "iResolution" 给我们提供了屏幕的宽高
// "iResolution.x" 是帧画面的宽度
// "iResolution.y" 是帧画面的高度
void main() {
  vec3 color1 = vec3(0.741, 0.635, 0.471);
  vec3 color2 = vec3(0.192, 0.329, 0.439);
  vec3 pixel;

	// 可以使用三元表达式
  pixel = (gl_FragCoord.x > iResolution.x / 2.0) ? color1 : color2;

  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 7
// 坐标转换

// 在大多数情况下，使用我们自己的坐标系比使用屏幕坐标更方便

// 创建并使用新的坐标系"r"，而不是绝对屏幕坐标"gl_FragCoord"
// 在"r"中，x 和 y 坐标将从 0 到 1
// 对于x，0是左侧，而1是右侧。对于y，0是底边，而1是上边.

void main() {
  vec2 r = vec2(gl_FragCoord.x / iResolution.x, gl_FragCoord.y / iResolution.y);
  // r 是 vec2，它的第一个分量是像素x坐标除以帧宽度，第二个分量是像素y坐标除以帧高度

  // 例如 1440 x 900 的屏幕，iResolution 是 vec2(1440.0, 900.0)
  // main 函数会执行 1440*900=1296000 次来生成一个帧画面
  // gl_FragCoord.x 的值将介于0和1439之间，而 gl_FragCoord.y 的值将介于0和899之间
  // r.x 和 r.y 的值将介于[0,1]之间

  vec3 color1 = vec3(0.841, 0.582, 0.594);
  vec3 color2 = vec3(0.884, 0.850, 0.648);
  vec3 color3 = vec3(0.348, 0.555, 0.641);
  vec3 pixel;

  if (r.x < 1.0 / 3.0) {
    pixel = color1;
  } else if (r.x < 2.0 / 3.0) {
    pixel = color2;
  } else {
    pixel = color3;
  }

  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 8
// 水平线和垂直线
void main() {
  vec2 r = vec2(gl_FragCoord.xy / iResolution.xy);
  // "aVector.xy" 是由 "aVector" 前两个分量组成的新 vec2
  // 在向量之间应用除法运算符时，第一个向量的每个分量除以第二个向量的对应分量

  vec3 backgroundColor = vec3(1.0);
  vec3 color1 = vec3(0.216, 0.471, 0.698);
  vec3 color2 = vec3(1.00, 0.329, 0.298);
  vec3 color3 = vec3(0.867, 0.910, 0.247);

  // 首先设置背景色，如果以后不覆盖像素值，则将显示该颜色
  vec3 pixel = backgroundColor;

  // 如果当前像素的x坐标在这些值之间，则将颜色设置为1。
  // 0.55和0.54之间的差确定线的宽度
  float leftCoord = 0.54;
  float rightCoord = 0.55;
  if (r.x < rightCoord && r.x > leftCoord) pixel = color1;

  // 用x坐标和粗细表示垂直线的另一种方式
  float lineCoordinate = 0.4;
  float lineThickness = 0.003;
  if (abs(r.x - lineCoordinate) < lineThickness) pixel = color2;

  // 一条水平线
  if (abs(r.y - 0.6) < 0.01) pixel = color3;

  // 水平线在垂直线的上方，因为它是最后一个设置"像素"值的像素

  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 9
// 可视化坐标系

// 使用for循环以及水平线和垂直线绘制坐标网格
void main() {
  vec2 r = vec2(gl_FragCoord.xy / iResolution.xy);

  vec3 backgroundColor = vec3(1.0);

  vec3 pixel = backgroundColor;

  vec3 axesColor = vec3(0.0, 0.0, 1.0);
  vec3 gridColor = vec3(0.5);

  // 画网格线
  // 使用 "const" 因为循环变量只能是常量表达式
  const float tickWidth = 0.1;
  for (float i = 0.0; i < 1.0; i += tickWidth) {
    // "i" 是线坐标
    if (abs(r.x - i) < 0.002) pixel = gridColor;
    if (abs(r.y - i) < 0.002) pixel = gridColor;
  }

  // 画坐标轴
  if (abs(r.x) < 0.005) pixel = axesColor;
  if (abs(r.y) < 0.006) pixel = axesColor;

  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 10
// 将坐标中心移动到帧画面的中心

// 这次不是将[0，iResolution.x] x [0，iResolution.y]区域映射到[0,1] x [0,1]
// 将其映射到[-1,1] x [-1,1]。这样，坐标（0,0）不会在屏幕的左下角，而是在屏幕的中间
void main() {
  vec2 r = vec2(gl_FragCoord.xy - 0.5 * iResolution.xy);
  // [0, iResolution.x] -> [-0.5*iResolution.x, 0.5*iResolution.x]
  // [0, iResolution.y] -> [-0.5*iResolution.y, 0.5*iResolution.y]
  r = 2.0 * r.xy / iResolution.xy;
  // [-0.5*iResolution.x, 0.5*iResolution.x] -> [-1.0, 1.0]

  vec3 backgroundColor = vec3(1.0);
  vec3 axesColor = vec3(0.0, 0.0, 1.0);
  vec3 gridColor = vec3(0.5);

  vec3 pixel = backgroundColor;

  // 画网格线
  // 不再使用遍历每个像素的循环，而是使用 mod（模除） 操作通过一次计算即可获得相同的结果
	// https://thebookofshaders.com/glossary/?search=mod
  const float tickWidth = 0.1;
  if (mod(r.x, tickWidth) < 0.008) pixel = gridColor;
  if (mod(r.y, tickWidth) < 0.008) pixel = gridColor;

  // 绘制坐标轴
  if (abs(r.x) < 0.006) pixel = axesColor;
  if (abs(r.y) < 0.007) pixel = axesColor;

  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 11
// 坐标系宽高比标准化

// 前面的例子中，当绘制坐标系时，我们得到的是矩形而不是正方形
// 我们将相同的数值间隔[0,1]分配给了不同的物理距离，实际上帧画面的宽度大于其高度
// 为了保持纵横比，我们不应将实际距离[0，iResolution.x]和[0，iResolution.y]映射到相同的间隔
void main() {
  vec2 r = vec2(gl_FragCoord.xy - 0.5 * iResolution.xy);
  r = 2.0 * r.xy / iResolution.y;

	// 不是将r.x除以iResolution.x、将r.y除以iResolution.y
	// 而是将它们都除以 iResolution.y

  // r.y 将处于 [-1.0，1.0]
  // r.x 将取决于帧画面尺寸，rx 将处于 [-1.78，1.78]

  vec3 backgroundColor = vec3(1.0);
  vec3 axesColor = vec3(0.0, 0.0, 1.0);
  vec3 gridColor = vec3(0.5);

  vec3 pixel = backgroundColor;

  // 画网格线
  const float tickWidth = 0.1;
  for (float i = -2.0; i < 2.0; i += tickWidth) {
    if (abs(r.x - i) < 0.004) pixel = gridColor;
    if (abs(r.y - i) < 0.004) pixel = gridColor;
  }
  // 绘制轴
  if (abs(r.x) < 0.006) pixel = axesColor;
  if (abs(r.y) < 0.007) pixel = axesColor;

  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 12
// 圆盘

// 我们使用一个间接命令，例如"如果像素坐标位于此磁盘内，则将颜色用作像素"
// 要习惯这种不直观的思维方式
void main() {
  vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;

  vec3 bgCol = vec3(0.3);
  vec3 colBlue = vec3(0.216, 0.471, 0.698);
  vec3 colRed = vec3(1.00, 0.329, 0.298);
  vec3 colYellow = vec3(0.867, 0.910, 0.247);

  vec3 pixel = bgCol;

  // 要绘制形状，我们应该知道该形状的解析几何表达式
  // 圆是与圆心距离相同的点集，该距离称为半径
  // 距离坐标系中点的距离计算 radius = sqrt(x*x + y*y)
  // 圆内的点，即圆盘，表示为 sqrt(x*x + y*y) < radius
  // 两边取平方得到 x*x + y*y < radius*radius
  float radius = 1.0;
  if (r.x * r.x + r.y * r.y < radius * radius) {
    pixel = colBlue;
  }

  // vec2 向量的 sqrt 有个简写是 length
  if (length(r) < 0.3) {
    pixel = colYellow;
  }

  // 绘制一个中心不在（0,0）的圆盘
  // 圆心在 c (c.x, c.y)
  // 任何点的距离r: (r.x, r.y) 到 c sqrt((r.x-c.x)^2+(r.y-c.y)^2)
  // 定义距离向量 d: (r.x - c.x, r.y - c.y)
  // d = r - c
  // 就像在除法中一样，两个向量的减法是逐个分量进行的
  // length(d) 等价于 sqrt(d.x^2+d.y^2)
  vec2 center = vec2(1.0, -1.0);
  vec2 d = r - center;
  if (length(d) < 1.0) {
    pixel = colRed;
  }
  // 形状中心的这种移动适用于任何形状 

  gl_FragColor = vec4(pixel, 1.0);
}

// 请注意如何显示最新的圆盘，而之前的圆盘则留在后面
// 这是因为最后一个if条件最终改变了像素值
// 如果像素的坐标适合多个if条件，则最后的操作将保留，并将gl_FragColor设置为该条件

#elif TUTORIAL == 13
// 多个函数

// 函数非常适合代码重用。让我们将圆盘代码放入函数中，并使用该函数进行绘图

// 我们将像素作为输入, "inout"是GLSL的特殊关键字
// 默认情况下，所有参数均为 "in" 参数
// 这意味着，变量的值从调用函数的作用域中提供给函数作用域
// "输出"变量将变量的值从函数传递到调用函数的作用域

// "inout"变量将变量的值作为参数发送给函数，然后，在函数内部处理该变量
// 函数结束时，将在调用函数的位置更新变量的值
// 也就是说带有 input 标识符的变量可以在函数内被修改

// 使用 main 函数的背景色初始化的"像素"变量
// 然后 pixel 传递给 dist 函数
// 如果满足if条件，则使用"color"参数更改"pixel"的值
// 如果不满足条件，则不更改 pixel，并使其保持先前的值（即 "bgColor"）
void disk(vec2 r, vec2 center, float radius, vec3 color, inout vec3 pixel) {
  if (length(r - center) < radius) {
    pixel = color;
  }
}

void main() {
  vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;

  vec3 bgCol = vec3(0.3);
  vec3 red = vec3(1.00, 0.329, 0.298);
  vec3 yellow = vec3(0.867, 0.910, 0.247);
  vec3 blue = vec3(0.216, 0.471, 0.698);

  vec3 pixel = bgCol;

  disk(r, vec2(0.1, 0.3), 0.3, red, pixel);
  disk(r, vec2(0.0, 0.0), .15, yellow, pixel);
  disk(r, vec2(-0.8, -0.6), 0.4, blue, pixel);

  gl_FragColor = vec4(pixel, 1.0);
}

// 如您所见，圆盘的边界具有“锯齿状”曲线，可以看到单个像素
// 这称为“锯齿”。发生这种情况是因为像素的大小有限，我们希望在不连续的网格上绘制连续的形状
// 有一种减少混叠的方法，通过在边框处混合内部颜色和外部颜色来完成此操作
// 为此，我们必须学习一些内置函数

// 请注意圆盘函数调用的顺序以及它们如何相互绘制
// 每个圆盘函数都会操纵pixel变量
// 如果一个 pixel 由多个圆盘函数操纵，则最后一个像素的值将发送到 gl_FragColor

// 在这种情况下，先前的值将被完全覆盖
// 最终值仅取决于操纵像素的最后一个函数，层之间没有混合物

#elif TUTORIAL == 14
// 内置函数：STEP
//
// "step" 函数：http://en.wikipedia.org/wiki/Heaviside_step_function
//
// f(x0, x) = {1 x>x0,
//            {0 x<x0
void main() {
  vec2 r = 2.0 * vec2(gl_FragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float aspectRatio = iResolution.x / iResolution.y;

  vec3 bgCol = vec3(0.0);

  vec3 pixel = bgCol;

  float edge, variable, ret;

  // 将屏幕水平分为五个部分，以用于不同的示例
	// [-1.0, -0.6)、[-0.6, -0.2)、[-0.2, 0.2), [0.2, 0.6)、[0.6, 1.0]

  if (r.x < -0.6 * aspectRatio) { // Part I
    variable = r.y;
    edge = 0.2; // 相对于 [-1.0, 1.0]
    if (variable > edge) {  // 如果 r.y 大于 edge 显示白色
      ret = 1.0;
    } else {                // 如果 r.y 小于 edge 显示白色
      ret = 0.0;
    }
  } else if (r.x < -0.2 * aspectRatio) { // Part II
    variable = r.y;
    edge = -0.2;
    ret = step(edge, variable);   // step function 等同于第一部分的 if 语句
  } else if (r.x < 0.2 * aspectRatio) { // Part III
    // "step" 返回 0.0 或者 1.0，"1.0 - step" 会反转输出
    ret = 1.0 - step(0.5, r.y);   // 反转 0.0 或 1.0 的输出
  } else if (r.x < 0.6 * aspectRatio) { // Part IV
    // 如果y坐标小于-0.4，则ret为0.3
    // 如果y坐标大于-0.4，则ret为0.3 + 0.5 = 0.8
    ret = 0.3 + 0.5 * step(-0.4, r.y);
  } else { // Part V
    // 结合两个 step 函数，创造间隙
    ret = step(-0.3, r.y) * (1.0 - step(0.3, r.y)); // https://thebookofshaders.com/glossary/?search=step
  }

  pixel = vec3(ret);
  gl_FragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 15
// BUILT-IN FUNCTIONS: CLAMP
//
// "clamp" function saturates the input below and above the thresholds
// f(x, min, max) = { max x>max
//                  { x   max>x>min
//                  { min min>x
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  // use [0,1] coordinate system for this example

  vec3 bgCol = vec3(0.0);                 // black
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 pixel = bgCol;

  float edge, variable, ret;

  // divide the screen into four parts horizontally for different
  // examples
  if (p.x < 0.25) {        // Part I
    ret = p.y;             // the brightness value is assigned the y coordinate
                           // it'll create a gradient
  } else if (p.x < 0.5) {  // Part II
    float minVal = 0.3;    // implementation of clamp
    float maxVal = 0.6;
    float variable = p.y;
    if (variable < minVal) {
      ret = minVal;
    }
    if (variable > minVal && variable < maxVal) {
      ret = variable;
    }
    if (variable > maxVal) {
      ret = maxVal;
    }
  } else if (p.x < 0.75) {  // Part III
    float minVal = 0.6;
    float maxVal = 0.8;
    float variable = p.y;
    ret = clamp(variable, minVal, maxVal);
  } else {                            // Part IV
    float y = cos(5. * TWOPI * p.y);  // oscillate between +1 and -1
                                      // 5 times, vertically
    y = (y + 1.0) * 0.5;              // map [-1,1] to [0,1]
    ret = clamp(y, 0.2, 0.8);
  }

  pixel = vec3(ret);  // make a color out of return value.
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 16
// BUILT-IN FUNCTIONS: SMOOTHSTEP
//
// "smoothstep" function is like step function but instead of a
// sudden jump from 0 to 1 at the edge, it makes a smooth transition
// in a given interval
// http://en.wikipedia.org/wiki/Smoothstep
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  // use [0,1] coordinate system for this example

  vec3 bgCol = vec3(0.0);                 // black
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // red
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // yellow

  vec3 pixel = bgCol;

  float edge, variable, ret;

  // divide the screen into four parts horizontally for different
  // examples
  if (p.x < 1. / 5.) {  // Part I
    float edge = 0.5;
    ret = step(edge, p.y);     // simple step function
  } else if (p.x < 2. / 5.) {  // Part II
    // linearstep (not a builtin function)
    float edge0 = 0.45;
    float edge1 = 0.55;
    float t = (p.y - edge0) / (edge1 - edge0);
    // when p.y == edge0 => t = 0.0
    // when p.y == edge1 => t = 1.0
    // RHS is a linear function of y
    // so, between edge0 and edge1, t has a linear transition
    // between 0.0 and 1.0
    float t1 = clamp(t, 0.0, 1.0);
    // t will have negative values when t<edge0 and
    // t will have greater than 1.0 values when t>edge1
    // but we want it be constraint between 0.0 and 1.0
    // so, clamp it!
    ret = t1;
  } else if (p.x < 3. / 5.) {  // Part III
    // implementation of smoothstep
    float edge0 = 0.45;
    float edge1 = 0.55;
    float t = clamp((p.y - edge0) / (edge1 - edge0), 0.0, 1.0);
    float t1 = 3.0 * t * t - 2.0 * t * t * t;
    // previous interpolation was linear. Visually it does not
    // give an appealing, smooth transition.
    // To achieve smoothness, implement a cubic Hermite polynomial
    // 3*t^2 - 2*t^3
    ret = t1;
  } else if (p.x < 4. / 5.) {  // Part IV
    ret = smoothstep(0.45, 0.55, p.y);
  } else if (p.x < 5. / 5.) {  // Part V
    // smootherstep, a suggestion by Ken Perlin
    float edge0 = 0.45;
    float edge1 = 0.55;
    float t = clamp((p.y - edge0) / (edge1 - edge0), 0.0, 1.0);
    // 6*t^5 - 15*t^4 + 10*t^3
    float t1 = t * t * t * (t * (t * 6. - 15.) + 10.);
    ret = t1;
    // faster transition and still smoother
    // but computationally more involved.
  }

  pixel = vec3(ret);  // make a color out of return value.
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 17
// BUILT-IN FUNCTIONS: MIX
//
// A shader can be created by first constructing individual parts
// and composing them together.
// There are different ways of how to combine different parts.
// In the previous disk example, different disks were drawn on top
// of each other. There was no mixture of layers. When disks
// overlap, only the last one is visible.
//
// Let's learn mixing different data types (in this case vec3's
// representing colors
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);

  vec3 bgCol = vec3(0.3);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // red
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // yellow

  vec3 ret;

  // divide the screen into four parts horizontally for different
  // examples
  if (p.x < 1. / 5.) {  // Part I
    // implementation of mix
    float x0 = 0.2;  // first item to be mixed
    float x1 = 0.7;  // second item to be mixed
    float m = 0.1;   // amount of mix (between 0.0 and 1.0)
    // play with this number
    // m = 0.0 means the output is fully x0
    // m = 1.0 means the output is fully x1
    // 0.0 < m < 1.0 is a linear mixture of x0 and x1
    float val = x0 * (1.0 - m) + x1 * m;
    ret = vec3(val);
  } else if (p.x < 2. / 5.) {  // Part II
    // try all possible mix values
    float x0 = 0.2;
    float x1 = 0.7;
    float m = p.y;
    float val = x0 * (1.0 - m) + x1 * m;
    ret = vec3(val);
  } else if (p.x < 3. / 5.) {  // Part III
    // use the mix function
    float x0 = 0.2;
    float x1 = 0.7;
    float m = p.y;
    float val = mix(x0, x1, m);
    ret = vec3(val);
  } else if (p.x < 4. / 5.) {  // Part IV
    // mix colors instead of numbers
    float m = p.y;
    ret = mix(col1, col2, m);
  } else if (p.x < 5. / 5.) {  // Part V
    // combine smoothstep and mix for color transition
    float m = smoothstep(0.5, 0.6, p.y);
    ret = mix(col1, col2, m);
  }

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 18
// ANTI-ALIASING WITH SMOOTHSTEP
//
float linearstep(float edge0, float edge1, float x) {
  float t = (x - edge0) / (edge1 - edge0);
  return clamp(t, 0.0, 1.0);
}
float smootherstep(float edge0, float edge1, float x) {
  float t = (x - edge0) / (edge1 - edge0);
  float t1 = t * t * t * (t * (t * 6. - 15.) + 10.);
  return clamp(t1, 0.0, 1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 bgCol = vec3(0.3);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 pixel = bgCol;
  float m;

  float radius = 0.4;       // increase this to see the effect better
  if (r.x < -0.5 * xMax) {  // Part I
    // no interpolation, yes aliasing
    m = step(radius, length(r - vec2(-0.5 * xMax - 0.4, 0.0)));
    // if the distance from the center is smaller than radius,
    // then mix value is 0.0
    // otherwise the mix value is 1.0
    pixel = mix(col1, bgCol, m);
  } else if (r.x < -0.0 * xMax) {  // Part II
    // linearstep (first order, linear interpolation)
    m = linearstep(radius - 0.005, radius + 0.005,
                   length(r - vec2(-0.0 * xMax - 0.4, 0.0)));
    // mix value is linearly interpolated when the distance to the center
    // is 0.005 smaller and greater than the radius.
    pixel = mix(col1, bgCol, m);
  } else if (r.x < 0.5 * xMax) {  // Part III
    // smoothstep (cubical interpolation)
    m = smoothstep(radius - 0.005, radius + 0.005,
                   length(r - vec2(0.5 * xMax - 0.4, 0.0)));
    pixel = mix(col1, bgCol, m);
  } else if (r.x < 1.0 * xMax) {  // Part IV
    // smootherstep (sixth order interpolation)
    m = smootherstep(radius - 0.005, radius + 0.005,
                     length(r - vec2(1.0 * xMax - 0.4, 0.0)));
    pixel = mix(col1, bgCol, m);
  }

  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 19
// FUNCTION PLOTTING
//
// It is always useful to see the plots of functions on cartesian
// coordinate system, to understand what they are doing precisely
//
// Let's plot some 1D functions!
//
// If y value is a function f of x value, the expression of their
// relation is: y = f(x)
// in other words, the plot of a function is all points
// that satisfy the expression: y-f(x)=0
// this set has 0 thickness, and can't be seen.
// Instead use the set of (x,y) that satisfy: -d < y-f(x) < d
// in other words abs(y-f(x)) < d
// where d is the thickness. (the thickness in in y direction)
// Because of the properties of absolute function, the condition
// abs(y-f(x)) < d is equivalent to the condition:
// abs(f(x) - y) < d
// We'll use this last one for function plotting. (in the previous one
// we have to negate the function that we want to plot)
float linearstep(float edge0, float edge1, float x) {
  float t = (x - edge0) / (edge1 - edge0);
  return clamp(t, 0.0, 1.0);
}
float smootherstep(float edge0, float edge1, float x) {
  float t = (x - edge0) / (edge1 - edge0);
  float t1 = t * t * t * (t * (t * 6. - 15.) + 10.);
  return clamp(t1, 0.0, 1.0);
}

void plot(vec2 r, float y, float lineThickness, vec3 color, inout vec3 pixel) {
  if (abs(y - r.y) < lineThickness) pixel = color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;

  vec3 bgCol = vec3(1.0);
  vec3 axesCol = vec3(0.0, 0.0, 1.0);
  vec3 gridCol = vec3(0.5);
  vec3 col1 = vec3(0.841, 0.582, 0.594);
  vec3 col2 = vec3(0.884, 0.850, 0.648);
  vec3 col3 = vec3(0.348, 0.555, 0.641);

  vec3 pixel = bgCol;

  // Draw grid lines
  const float tickWidth = 0.1;
  for (float i = -2.0; i < 2.0; i += tickWidth) {
    // "i" is the line coordinate.
    if (abs(r.x - i) < 0.004) pixel = gridCol;
    if (abs(r.y - i) < 0.004) pixel = gridCol;
  }
  // Draw the axes
  if (abs(r.x) < 0.006) pixel = axesCol;
  if (abs(r.y) < 0.007) pixel = axesCol;

  // Draw functions
  float x = r.x;
  float y = r.y;
  // pink functions
  // y = 2*x + 5
  if (abs(2. * x + .5 - y) < 0.02) pixel = col1;
  // y = x^2 - .2
  if (abs(r.x * r.x - 0.2 - y) < 0.01) pixel = col1;
  // y = sin(PI x)
  if (abs(sin(PI * r.x) - y) < 0.02) pixel = col1;

  // blue functions, the step function variations
  // (functions are scaled and translated vertically)
  if (abs(0.25 * step(0.0, x) + 0.6 - y) < 0.01) pixel = col3;
  if (abs(0.25 * linearstep(-0.5, 0.5, x) + 0.1 - y) < 0.01) pixel = col3;
  if (abs(0.25 * smoothstep(-0.5, 0.5, x) - 0.4 - y) < 0.01) pixel = col3;
  if (abs(0.25 * smootherstep(-0.5, 0.5, x) - 0.9 - y) < 0.01) pixel = col3;

  // yellow functions
  // have a function that plots functions :-)
  plot(r, 0.5 * clamp(sin(TWOPI * x), 0.0, 1.0) - 0.7, 0.015, col2, pixel);
  // bell curve around -0.5
  plot(r, 0.6 * exp(-10.0 * (x + 0.8) * (x + 0.8)) - 0.1, 0.015, col2, pixel);

  fragColor = vec4(pixel, 1.0);
}
// in the future we can use this framework to see the plot of functions
// and design and find functions for our liking
// Actually using Mathematica, Matlab, matplotlib etc. to plot functions
// is much more practical. But they need a translation of functions
// from GLSL to their language. Here we can plot the native implementations
// of GLSL functions.

#elif TUTORIAL == 20
// COLOR ADDITION AND SUBSTRACTION
//
// How to draw a shape on top of another, and how will the layers
// below, affect the higher layers?
//
// In the previous shape drawing functions, we set the pixel
// value from the function. This time the shape function will
// just return a float value between 0.0 and 1.0 to indice the
// shape area. Later that value can be multiplied with some color
// and used in determining the final pixel color.

// A function that returns the 1.0 inside the disk area
// returns 0.0 outside the disk area
// and has a smooth transition at the radius
float disk(vec2 r, vec2 center, float radius) {
  float distanceFromCenter = length(r - center);
  float outsideOfDisk =
      smoothstep(radius - 0.005, radius + 0.005, distanceFromCenter);
  float insideOfDisk = 1.0 - outsideOfDisk;
  return insideOfDisk;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 black = vec3(0.0);
  vec3 white = vec3(1.0);
  vec3 gray = vec3(0.3);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // red
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // yellow

  vec3 ret;
  float d;

  if (p.x < 1. / 3.) {  // Part I
    // opaque layers on top of each other
    ret = gray;
    // assign a gray value to the pixel first
    d = disk(r, vec2(-1.1, 0.3), 0.4);
    ret = mix(ret, col1, d);  // mix the previous color value with
                              // the new color value according to
                              // the shape area function.
                              // at this line, previous color is gray.
    d = disk(r, vec2(-1.3, 0.0), 0.4);
    ret = mix(ret, col2, d);
    d = disk(r, vec2(-1.05, -0.3), 0.4);
    ret = mix(ret, col3, d);   // here, previous color can be gray,
                               // blue or pink.
  } else if (p.x < 2. / 3.) {  // Part II
    // Color addition
    // This is how lights of different colors add up
    // http://en.wikipedia.org/wiki/Additive_color
    ret = black;                                 // start with black pixels
    ret += disk(r, vec2(0.1, 0.3), 0.4) * col1;  // add the new color
                                                 // to the previous color
    ret += disk(r, vec2(-.1, 0.0), 0.4) * col2;
    ret += disk(r, vec2(.15, -0.3), 0.4) * col3;
    // when all components of "ret" becomes equal or higher than 1.0
    // it becomes white.
  } else if (p.x < 3. / 3.) {  // Part III
    // Color substraction
    // This is how dye of different colors add up
    // http://en.wikipedia.org/wiki/Subtractive_color
    ret = white;  // start with white
    ret -= disk(r, vec2(1.1, 0.3), 0.4) * col1;
    ret -= disk(r, vec2(1.05, 0.0), 0.4) * col2;
    ret -= disk(r, vec2(1.35, -0.25), 0.4) * col3;
    // when all components of "ret" becomes equals or smaller than 0.0
    // it becomes black.
  }

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 21
// COORDINATE TRANSFORMATIONS: ROTATION
//
// Up to now, we translated to coordinate center to draw geometric
// shapes at different parts of the screen.
// Lets learn how to rotate the shapes.

// a function that draws an (anti-aliased) grid of coordinate system
float coordinateGrid(vec2 r) {
  vec3 axesCol = vec3(0.0, 0.0, 1.0);
  vec3 gridCol = vec3(0.5);
  float ret = 0.0;

  // Draw grid lines
  const float tickWidth = 0.1;
  for (float i = -2.0; i < 2.0; i += tickWidth) {
    // "i" is the line coordinate.
    ret += 1. - smoothstep(0.0, 0.008, abs(r.x - i));
    ret += 1. - smoothstep(0.0, 0.008, abs(r.y - i));
  }
  // Draw the axes
  ret += 1. - smoothstep(0.001, 0.015, abs(r.x));
  ret += 1. - smoothstep(0.001, 0.015, abs(r.y));
  return ret;
}
// returns 1.0 if inside circle
float disk(vec2 r, vec2 center, float radius) {
  return 1.0 - smoothstep(radius - 0.005, radius + 0.005, length(r - center));
}
// returns 1.0 if inside the rectangle
float rectangle(vec2 r, vec2 topLeft, vec2 bottomRight) {
  float ret;
  float d = 0.005;
  ret = smoothstep(topLeft.x - d, topLeft.x + d, r.x);
  ret *= smoothstep(topLeft.y - d, topLeft.y + d, r.y);
  ret *= 1.0 - smoothstep(bottomRight.y - d, bottomRight.y + d, r.y);
  ret *= 1.0 - smoothstep(bottomRight.x - d, bottomRight.x + d, r.x);
  return ret;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 bgCol = vec3(1.0);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 ret;

  vec2 q;
  float angle;
  angle = 0.2 * PI;  // angle in radians (PI is 180 degrees)
  // q is the rotated coordinate system
  q.x = cos(angle) * r.x + sin(angle) * r.y;
  q.y = -sin(angle) * r.x + cos(angle) * r.y;

  ret = bgCol;
  // draw the old and new coordinate systems
  ret = mix(ret, col1, coordinateGrid(r) * 0.4);
  ret = mix(ret, col2, coordinateGrid(q));

  // draw shapes in old coordinate system, r, and new coordinate system, q
  ret = mix(ret, col1, disk(r, vec2(1.0, 0.0), 0.2));
  ret = mix(ret, col2, disk(q, vec2(1.0, 0.0), 0.2));
  ret = mix(ret, col1, rectangle(r, vec2(-0.8, 0.2), vec2(-0.5, 0.4)));
  ret = mix(ret, col2, rectangle(q, vec2(-0.8, 0.2), vec2(-0.5, 0.4)));
  // as you see both circle are drawn at the same coordinate, (1,0),
  // in their respective coordinate systems. But they appear
  // on different locations of the screen

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 22
// COORDINATE TRANSFORMATIONS: SCALING
//
// Scaling the coordinate system.

// a function that draws an (anti-aliased) grid of coordinate system
float coordinateGrid(vec2 r) {
  vec3 axesCol = vec3(0.0, 0.0, 1.0);
  vec3 gridCol = vec3(0.5);
  float ret = 0.0;

  // Draw grid lines
  const float tickWidth = 0.1;
  for (float i = -2.0; i < 2.0; i += tickWidth) {
    // "i" is the line coordinate.
    ret += 1. - smoothstep(0.0, 0.008, abs(r.x - i));
    ret += 1. - smoothstep(0.0, 0.008, abs(r.y - i));
  }
  // Draw the axes
  ret += 1. - smoothstep(0.001, 0.015, abs(r.x));
  ret += 1. - smoothstep(0.001, 0.015, abs(r.y));
  return ret;
}
// returns 1.0 if inside circle
float disk(vec2 r, vec2 center, float radius) {
  return 1.0 - smoothstep(radius - 0.005, radius + 0.005, length(r - center));
}
// returns 1.0 if inside the rectangle
float rectangle(vec2 r, vec2 topLeft, vec2 bottomRight) {
  float ret;
  float d = 0.005;
  ret = smoothstep(topLeft.x - d, topLeft.x + d, r.x);
  ret *= smoothstep(topLeft.y - d, topLeft.y + d, r.y);
  ret *= 1.0 - smoothstep(bottomRight.y - d, bottomRight.y + d, r.y);
  ret *= 1.0 - smoothstep(bottomRight.x - d, bottomRight.x + d, r.x);
  return ret;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 bgCol = vec3(1.0);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 ret = bgCol;

  // original
  ret = mix(ret, col1, coordinateGrid(r) / 2.0);
  // scaled
  float scaleFactor = 3.3;  // zoom in this much
  vec2 q = r / scaleFactor;
  ret = mix(ret, col2, coordinateGrid(q) / 2.0);

  ret = mix(ret, col2, disk(q, vec2(0.0, 0.0), 0.1));
  ret = mix(ret, col1, disk(r, vec2(0.0, 0.0), 0.1));

  ret = mix(ret, col1, rectangle(r, vec2(-0.5, 0.0), vec2(-0.2, 0.2)));
  ret = mix(ret, col2, rectangle(q, vec2(-0.5, 0.0), vec2(-0.2, 0.2)));

  // note how the rectangle that are not centered at the coordinate origin
  // changed its location after scaling, but the disks at the center
  // remained where they are.
  // This is because scaling is done by multiplying all pixel
  // coordinates with a constant.

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 23
// SUCCESSIVE COORDINATE TRANSFORMATIONS
//
// Drawing a shape on the desired location, with desired size, and
// desired orientation needs mastery of succesive application of
// transformations.
//
// In general, transformations do not commute. Which means that
// if you change their order, you get different results.
//
// Let's try application of transformations in different orders.

float coordinateGrid(vec2 r) {
  vec3 axesCol = vec3(0.0, 0.0, 1.0);
  vec3 gridCol = vec3(0.5);
  float ret = 0.0;

  // Draw grid lines
  const float tickWidth = 0.1;
  for (float i = -2.0; i < 2.0; i += tickWidth) {
    // "i" is the line coordinate.
    ret += 1. - smoothstep(0.0, 0.008, abs(r.x - i));
    ret += 1. - smoothstep(0.0, 0.008, abs(r.y - i));
  }
  // Draw the axes
  ret += 1. - smoothstep(0.001, 0.015, abs(r.x));
  ret += 1. - smoothstep(0.001, 0.015, abs(r.y));
  return ret;
}
// returns 1.0 if inside circle
float disk(vec2 r, vec2 center, float radius) {
  return 1.0 - smoothstep(radius - 0.005, radius + 0.005, length(r - center));
}
// returns 1.0 if inside the disk
float rectangle(vec2 r, vec2 topLeft, vec2 bottomRight) {
  float ret;
  float d = 0.005;
  ret = smoothstep(topLeft.x - d, topLeft.x + d, r.x);
  ret *= smoothstep(topLeft.y - d, topLeft.y + d, r.y);
  ret *= 1.0 - smoothstep(bottomRight.y - d, bottomRight.y + d, r.y);
  ret *= 1.0 - smoothstep(bottomRight.x - d, bottomRight.x + d, r.x);
  return ret;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 bgCol = vec3(1.0);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 ret = bgCol;

  float angle = 0.6;
  mat2 rotationMatrix = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

  if (p.x < 1. / 2.) {  // Part I
    // put the origin at the center of Part I
    r = r - vec2(-xMax / 2.0, 0.0);

    vec2 rotated = rotationMatrix * r;
    vec2 rotatedTranslated = rotated - vec2(0.4, 0.5);
    ret = mix(ret, col1, coordinateGrid(r) * 0.3);
    ret = mix(ret, col2, coordinateGrid(rotated) * 0.3);
    ret = mix(ret, col3, coordinateGrid(rotatedTranslated) * 0.3);

    ret = mix(ret, col1, rectangle(r, vec2(-.1, -.2), vec2(0.1, 0.2)));
    ret = mix(ret, col2, rectangle(rotated, vec2(-.1, -.2), vec2(0.1, 0.2)));
    ret = mix(ret, col3,
              rectangle(rotatedTranslated, vec2(-.1, -.2), vec2(0.1, 0.2)));
  } else if (p.x < 2. / 2.) {  // Part II
    r = r - vec2(xMax * 0.5, 0.0);

    vec2 translated = r - vec2(0.4, 0.5);
    vec2 translatedRotated = rotationMatrix * translated;

    ret = mix(ret, col1, coordinateGrid(r) * 0.3);
    ret = mix(ret, col2, coordinateGrid(translated) * 0.3);
    ret = mix(ret, col3, coordinateGrid(translatedRotated) * 0.3);

    ret = mix(ret, col1, rectangle(r, vec2(-.1, -.2), vec2(0.1, 0.2)));
    ret = mix(ret, col2, rectangle(translated, vec2(-.1, -.2), vec2(0.1, 0.2)));
    ret = mix(ret, col3,
              rectangle(translatedRotated, vec2(-.1, -.2), vec2(0.1, 0.2)));
  }

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 24
// TIME, MOTION AND ANIMATION
//
// One of the inputs that a shader gets can be the time.
// In ShaderToy, "iTime" variable holds the value of the
// time in seconds since the shader is started.
//
// Let's change some variables in time!

float disk(vec2 r, vec2 center, float radius) {
  return 1.0 - smoothstep(radius - 0.005, radius + 0.005, length(r - center));
}

float rect(vec2 r, vec2 bottomLeft, vec2 topRight) {
  float ret;
  float d = 0.005;
  ret = smoothstep(bottomLeft.x - d, bottomLeft.x + d, r.x);
  ret *= smoothstep(bottomLeft.y - d, bottomLeft.y + d, r.y);
  ret *= 1.0 - smoothstep(topRight.y - d, topRight.y + d, r.y);
  ret *= 1.0 - smoothstep(topRight.x - d, topRight.x + d, r.x);
  return ret;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 ret;

  if (p.x < 1. / 5.) {  // Part I
    vec2 q = r + vec2(xMax * 4. / 5., 0.);
    ret = vec3(0.2);
    // y coordinate depends on time
    float y = iTime;
    // mod constraints y to be between 0.0 and 2.0,
    // and y jumps from 2.0 to 0.0
    // substracting -1.0 makes why jump from 1.0 to -1.0
    y = mod(y, 2.0) - 1.0;
    ret = mix(ret, col1, disk(q, vec2(0.0, y), 0.1));
  } else if (p.x < 2. / 5.) {  // Part II
    vec2 q = r + vec2(xMax * 2. / 5., 0.);
    ret = vec3(0.3);
    // oscillation
    float amplitude = 0.8;
    // y coordinate oscillates with a period of 0.5 seconds
    float y = 0.8 * sin(0.5 * iTime * TWOPI);
    // radius oscillates too
    float radius = 0.15 + 0.05 * sin(iTime * 8.0);
    ret = mix(ret, col1, disk(q, vec2(0.0, y), radius));
  } else if (p.x < 3. / 5.) {  // Part III
    vec2 q = r + vec2(xMax * 0. / 5., 0.);
    ret = vec3(0.4);
    // booth coordinates oscillates
    float x = 0.2 * cos(iTime * 5.0);
    // but they have a phase difference of PI/2
    float y = 0.3 * cos(iTime * 5.0 + PI / 2.0);
    float radius = 0.2 + 0.1 * sin(iTime * 2.0);
    // make the color mixture time dependent
    vec3 color = mix(col1, col2, sin(iTime) * 0.5 + 0.5);
    ret = mix(ret, color,
              rect(q, vec2(x - 0.1, y - 0.1), vec2(x + 0.1, y + 0.1)));
    // try different phases, different amplitudes and different frequencies
    // for x and y coordinates
  } else if (p.x < 4. / 5.) {  // Part IV
    vec2 q = r + vec2(-xMax * 2. / 5., 0.);
    ret = vec3(0.3);
    for (float i = -1.0; i < 1.0; i += 0.2) {
      float x = 0.2 * cos(iTime * 5.0 + i * PI);
      // y coordinate is the loop value
      float y = i;
      vec2 s = q - vec2(x, y);
      // each box has a different phase
      float angle = iTime * 3. + i;
      mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
      s = rot * s;
      ret = mix(ret, col1, rect(s, vec2(-0.06, -0.06), vec2(0.06, 0.06)));
    }
  } else if (p.x < 5. / 5.) {  // Part V
    vec2 q = r + vec2(-xMax * 4. / 5., 0.);
    ret = vec3(0.2);
    // let stop and move again periodically
    float speed = 2.0;
    float t = iTime * speed;
    float stopEveryAngle = PI / 2.0;
    float stopRatio = 0.5;
    float t1 = (floor(t) + smoothstep(0.0, 1.0 - stopRatio, fract(t))) *
               stopEveryAngle;

    float x = -0.2 * cos(t1);
    float y = 0.3 * sin(t1);
    float dx = 0.1 + 0.03 * sin(t * 10.0);
    float dy = 0.1 + 0.03 * sin(t * 10.0 + PI);
    ret = mix(ret, col1, rect(q, vec2(x - dx, y - dy), vec2(x + dx, y + dy)));
  }

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 25
// PLASMA EFFECT
//
// We said that the a pixel's color only depends on its coordinates
// and other inputs (such as time)
//
// There is an effect called Plasma, which is based on a mixture of
// complex function in the form of f(x,y).
//
// Let's write a plasma!
//
// http://en.wikipedia.org/wiki/Plasma_effect

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float t = iTime;
  r = r * 8.0;

  float v1 = sin(r.x + t);
  float v2 = sin(r.y + t);
  float v3 = sin(r.x + r.y + t);
  float v4 = sin(length(r) + 1.7 * t);
  float v = v1 + v2 + v3 + v4;

  vec3 ret;

  if (p.x < 1. / 10.) {  // Part I
    // vertical waves
    ret = vec3(v1);
  } else if (p.x < 2. / 10.) {  // Part II
    // horizontal waves
    ret = vec3(v2);
  } else if (p.x < 3. / 10.) {  // Part III
    // diagonal waves
    ret = vec3(v3);
  } else if (p.x < 4. / 10.) {  // Part IV
    // circular waves
    ret = vec3(v4);
  } else if (p.x < 5. / 10.) {  // Part V
    // the sum of all waves
    ret = vec3(v);
  } else if (p.x < 6. / 10.) {  // Part VI
    // Add periodicity to the gradients
    ret = vec3(sin(2. * v));
  } else if (p.x < 10. / 10.) {  // Part VII
    // mix colors
    v *= 1.0;
    ret = vec3(sin(v), sin(v + 0.5 * PI), sin(v + 1.0 * PI));
  }

  ret = 0.5 + 0.5 * ret;

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.);
}

#elif TUTORIAL == 26
// TEXTURES
//
// ShaderToy can use upto four textures.

float rect(vec2 r, vec2 bottomLeft, vec2 topRight) {
  float ret;
  float d = 0.005;
  ret = smoothstep(bottomLeft.x - d, bottomLeft.x + d, r.x);
  ret *= smoothstep(bottomLeft.y - d, bottomLeft.y + d, r.y);
  ret *= 1.0 - smoothstep(topRight.y - d, topRight.y + d, r.y);
  ret *= 1.0 - smoothstep(topRight.x - d, topRight.x + d, r.x);
  return ret;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 bgCol = vec3(0.3);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 ret;

  if (p.x < 1. / 3.) {  // Part I
    ret = texture(iChannel1, p).xyz;
  } else if (p.x < 2. / 3.) {  // Part II
    ret = texture(iChannel1, 4. * p + vec2(0., iTime)).xyz;
  } else if (p.x < 3. / 3.) {  // Part III
    r = r - vec2(xMax * 2. / 3., 0.);
    float angle = iTime;
    mat2 rotMat = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    vec2 q = rotMat * r;
    vec3 texA = texture(iChannel1, q).xyz;
    vec3 texB = texture(iChannel2, q).xyz;

    angle = -iTime;
    rotMat = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    q = rotMat * r;
    ret = mix(texA, texB, rect(q, vec2(-0.3, -0.3), vec2(.3, .3)));
  }

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 27
// MOUSE INPUT
//
// ShaderToy gives the mouse cursor coordinates and button clicks
// as an input via the iMouse vec4.
//
// Let's write a shader with basic Mouse functionality.
// When clicked on the frame, the little disk will follow the
// cursor. The x coordinate of the cursor changes the background color.
// And if the cursor is inside the bigger disk, it'll color will change.

float disk(vec2 r, vec2 center, float radius) {
  return 1.0 - smoothstep(radius - 0.5, radius + 0.5, length(r - center));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  // background color depends on the x coordinate of the cursor
  vec3 bgCol = vec3(iMouse.x / iResolution.x);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 ret = bgCol;

  vec2 center;
  // draw the big yellow disk
  center = vec2(100., iResolution.y / 2.);
  float radius = 60.;
  // if the cursor coordinates is inside the disk
  if (length(iMouse.xy - center) > radius) {
    // use color3
    ret = mix(ret, col3, disk(fragCoord.xy, center, radius));
  } else {
    // else use color2
    ret = mix(ret, col2, disk(fragCoord.xy, center, radius));
  }

  // draw the small blue disk at the cursor
  center = iMouse.xy;
  ret = mix(ret, col1, disk(fragCoord.xy, center, 20.));

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

#elif TUTORIAL == 28
// RANDOMNESS
//
// I don't know why, but GLSL does not have random number generators.
// This does not pose a problem if you are writing your code in
// a programming language that has random functions. That way
// you can generate the random values using the language and send
// those values to the shader via uniforms.
//
// But if you are using a system that only allows you to write
// the shader code, such as ShaderToy, then you need to write your own
// pseuo-random generators.
//
// Here is a pattern that I saw again and again in many different
// shaders at ShaderToy.
// Let's draw N different disks at random locations using this pattern.

float hash(float seed) {
  // Return a "random" number based on the "seed"
  return fract(sin(seed) * 43758.5453);
}

vec2 hashPosition(float x) {
  // Return a "random" position based on the "seed"
  return vec2(hash(x), hash(x * 1.1));
}

float disk(vec2 r, vec2 center, float radius) {
  return 1.0 - smoothstep(radius - 0.005, radius + 0.005, length(r - center));
}

float coordinateGrid(vec2 r) {
  vec3 axesCol = vec3(0.0, 0.0, 1.0);
  vec3 gridCol = vec3(0.5);
  float ret = 0.0;

  // Draw grid lines
  const float tickWidth = 0.1;
  for (float i = -2.0; i < 2.0; i += tickWidth) {
    // "i" is the line coordinate.
    ret += 1. - smoothstep(0.0, 0.005, abs(r.x - i));
    ret += 1. - smoothstep(0.0, 0.01, abs(r.y - i));
  }
  // Draw the axes
  ret += 1. - smoothstep(0.001, 0.005, abs(r.x));
  ret += 1. - smoothstep(0.001, 0.005, abs(r.y));
  return ret;
}

float plot(vec2 r, float y, float thickness) {
  return (abs(y - r.y) < thickness) ? 1.0 : 0.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = vec2(fragCoord.xy / iResolution.xy);
  vec2 r = 2.0 * vec2(fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  float xMax = iResolution.x / iResolution.y;

  vec3 bgCol = vec3(0.3);
  vec3 col1 = vec3(0.216, 0.471, 0.698);  // blue
  vec3 col2 = vec3(1.00, 0.329, 0.298);   // yellow
  vec3 col3 = vec3(0.867, 0.910, 0.247);  // red

  vec3 ret = bgCol;

  vec3 white = vec3(1.);
  vec3 gray = vec3(.3);
  if (r.y > 0.7) {
    // translated and rotated coordinate system
    vec2 q = (r - vec2(0., 0.9)) * vec2(1., 20.);
    ret = mix(white, gray, coordinateGrid(q));

    // just the regular sin function
    float y = sin(5. * q.x) * 2.0 - 1.0;

    ret = mix(ret, col1, plot(q, y, 0.1));
  } else if (r.y > 0.4) {
    vec2 q = (r - vec2(0., 0.6)) * vec2(1., 20.);
    ret = mix(white, col1, coordinateGrid(q));

    // take the decimal part of the sin function
    float y = fract(sin(5. * q.x)) * 2.0 - 1.0;

    ret = mix(ret, col2, plot(q, y, 0.1));
  } else if (r.y > 0.1) {
    vec3 white = vec3(1.);
    vec2 q = (r - vec2(0., 0.25)) * vec2(1., 20.);
    ret = mix(white, gray, coordinateGrid(q));

    // scale up the outcome of the sine function
    // increase the scale and see the transition from
    // periodic pattern to chaotic pattern
    float scale = 10.0;
    float y = fract(sin(5. * q.x) * scale) * 2.0 - 1.0;

    ret = mix(ret, col1, plot(q, y, 0.2));
  } else if (r.y > -0.2) {
    vec3 white = vec3(1.);
    vec2 q = (r - vec2(0., -0.0)) * vec2(1., 10.);
    ret = mix(white, col1, coordinateGrid(q));

    float seed = q.x;
    // Scale up with a big real number
    float y = fract(sin(seed) * 43758.5453) * 2.0 - 1.0;
    // this can be used as a pseudo-random value
    // These type of function, functions in which two inputs
    // that are close to each other (such as close q.x positions)
    // return highly different output values, are called "hash"
    // function.

    ret = mix(ret, col2, plot(q, y, 0.1));
  } else {
    vec2 q = (r - vec2(0., -0.6));

    // use the loop index as the seed
    // and vary different quantities of disks, such as
    // location and radius
    for (float i = 0.0; i < 6.0; i++) {
      // change the seed and get different distributions
      float seed = i + 0.0;
      vec2 pos = (vec2(hash(seed), hash(seed + 0.5)) - 0.5) * 3.;
      ;
      float radius = hash(seed + 3.5);
      pos *= vec2(1.0, 0.3);
      ret = mix(ret, col1, disk(q, pos, 0.2 * radius));
    }
  }

  vec3 pixel = ret;
  fragColor = vec4(pixel, 1.0);
}

/* End of tutorials */

#elif TUTORIAL == 0
// WELCOME SCREEN
float square(vec2 r, vec2 bottomLeft, float side) {
  vec2 p = r - bottomLeft;
  return (p.x > 0.0 && p.x < side && p.y > 0.0 && p.y < side) ? 1.0 : 0.0;
}

float character(vec2 r, vec2 bottomLeft, float charCode, float squareSide) {
  vec2 p = r - bottomLeft;
  float ret = 0.0;
  float num, quotient, remainder, divider;
  float x, y;
  num = charCode;
  for (int i = 0; i < 20; i++) {
    float boxNo = float(19 - i);
    divider = pow(2., boxNo);
    quotient = floor(num / divider);
    remainder = num - quotient * divider;
    num = remainder;

    y = floor(boxNo / 4.0);
    x = boxNo - y * 4.0;
    if (quotient == 1.) {
      ret += square(p, squareSide * vec2(x, y), squareSide);
    }
  }
  return ret;
}

mat2 rot(float th) { return mat2(cos(th), -sin(th), sin(th), cos(th)); }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  float G = 990623.;  // compressed characters :-)
  float L = 69919.;
  float S = 991119.;

  float t = iTime;

  vec2 r = (fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
  // vec2 rL = rot(t)*r+0.0001*t;
  // vec2 rL = r+vec2(cos(t*0.02),sin(t*0.02))*t*0.05;
  float c = 0.05;  //+0.03*sin(2.5*t);
  vec2 pL = (mod(r + vec2(cos(0.3 * t), sin(0.3 * t)), 2.0 * c) - c) / c;
  float circ = 1.0 - smoothstep(0.75, 0.8, length(pL));
  vec2 rG = rot(2. * 3.1415 * smoothstep(0., 1., mod(1.5 * t, 4.0))) * r;
  vec2 rStripes = rot(0.2) * r;

  float xMax = 0.5 * iResolution.x / iResolution.y;
  float letterWidth = 2.0 * xMax * 0.9 / 4.0;
  float side = letterWidth / 4.;
  float space = 2.0 * xMax * 0.1 / 5.0;

  r += 0.001;  // to get rid off the y=0 horizontal blue line.
  float maskGS = character(
      r,
      vec2(-xMax + space, -2.5 * side) + vec2(letterWidth + space, 0.0) * 0.0,
      G, side);
  float maskG = character(
      rG,
      vec2(-xMax + space, -2.5 * side) + vec2(letterWidth + space, 0.0) * 0.0,
      G, side);
  float maskL1 = character(
      r,
      vec2(-xMax + space, -2.5 * side) + vec2(letterWidth + space, 0.0) * 1.0,
      L, side);
  float maskSS = character(
      r,
      vec2(-xMax + space, -2.5 * side) + vec2(letterWidth + space, 0.0) * 2.0,
      S, side);
  float maskS = character(r,
                          vec2(-xMax + space, -2.5 * side) +
                              vec2(letterWidth + space, 0.0) * 2.0 +
                              vec2(0.01 * sin(2.1 * t), 0.012 * cos(t)),
                          S, side);
  float maskL2 = character(
      r,
      vec2(-xMax + space, -2.5 * side) + vec2(letterWidth + space, 0.0) * 3.0,
      L, side);
  float maskStripes = step(0.25, mod(rStripes.x - 0.5 * t, 0.5));

  float i255 = 0.00392156862;
  vec3 blue = vec3(43., 172., 181.) * i255;
  vec3 pink = vec3(232., 77., 91.) * i255;
  vec3 dark = vec3(59., 59., 59.) * i255;
  vec3 light = vec3(245., 236., 217.) * i255;
  vec3 green = vec3(180., 204., 18.) * i255;

  vec3 pixel = blue;
  pixel = mix(pixel, light, maskGS);
  pixel = mix(pixel, light, maskSS);
  pixel -= 0.1 * maskStripes;
  pixel = mix(pixel, green, maskG);
  pixel = mix(pixel, pink, maskL1 * circ);
  pixel = mix(pixel, green, maskS);
  pixel = mix(pixel, pink, maskL2 * (1. - circ));

  float dirt = pow(texture(iChannel0, 4.0 * r).x, 4.0);
  pixel -= (0.2 * dirt - 0.1) * (maskG + maskS);  // dirt
  pixel -= smoothstep(0.45, 2.5, length(r));
  fragColor = vec4(pixel, 1.0);
}
#endif