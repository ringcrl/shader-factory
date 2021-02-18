const elCanvas = document.getElementById('canvas');
const elPrintBtn = document.getElementById('print');
const elClearBtn = document.getElementById('clear');
const ctx = elCanvas.getContext('2d');
const SIZE = 500;

let t = 0; // 贝塞尔函数涉及的占比比例，0<=t<=1
let clickNodes = []; // 点击的控制点对象数组
let bezierNodes = []; // 绘制内部控制点的数组
let isPrinted = false; // 当前存在绘制的曲线
let isPrinting = false; // 正在绘制中
let num = 0; // 控制点数
let isDrag = false; // 是否进入拖拽行为
let isDragNode = false; // 是否点击到了控制点
let dragIndex = 0; // 被拖拽的点的索引
let clickon = 0; // 鼠标按下时间戳
let clickoff = 0; // 鼠标抬起

// function getRandomColor() {
//   return `#${Math.floor(Math.random() * 16777215).toString(16)}`;
// }

function factorial(num) {
  // 递归阶乘
  if (num <= 1) {
    return 1;
  }
  return num * factorial(num - 1);
}

function bezier(arr, t) {
  // 通过各控制点与占比t计算当前贝塞尔曲线上的点坐标
  let x = 0;
  let y = 0;
  const n = arr.length - 1;
  arr.forEach((item, index) => {
    if (!index) {
      x += item.x * Math.pow((1 - t), n - index) * Math.pow(t, index);
      y += item.y * Math.pow((1 - t), n - index) * Math.pow(t, index);
    } else {
      x += factorial(n)
        / factorial(index)
        / factorial(n - index)
        * item.x * Math.pow((1 - t), n - index) * Math.pow(t, index);
      y += factorial(n)
        / factorial(index)
        / factorial(n - index)
        * item.y * Math.pow((1 - t), n - index) * Math.pow(t, index);
    }
  });
  return {
    x,
    y,
  };
}

function drawnode(nodes) {
  if (!nodes.length) return;
  const _nodes = nodes;
  const next_nodes = [];
  _nodes.forEach((item, index) => {
    const { x } = item;
    const { y } = item;
    if (_nodes.length === num) {
      ctx.font = '16px Microsoft YaHei';
      const i = parseInt(index, 10) + 1;
      ctx.fillText(`p${i}`, x, y + 20);
      ctx.fillText(`p${i}: (${x}, ${y})`, 10, i * 20);
    }
    ctx.beginPath();
    ctx.arc(x, y, 4, 0, Math.PI * 2, false);
    ctx.fill();
    if (_nodes.length === 1) {
      bezierNodes.push(item);
      if (bezierNodes.length > 1) {
        bezierNodes.forEach((obj, i) => {
          if (i) {
            const startX = bezierNodes[i - 1].x;
            const startY = bezierNodes[i - 1].y;
            const { x } = obj;
            const { y } = obj;
            ctx.beginPath();
            ctx.moveTo(startX, startY);
            ctx.lineTo(x, y);
            ctx.strokeStyle = 'red';
            ctx.stroke();
          }
        });
      }
    }
    if (index) {
      const startX = _nodes[index - 1].x;
      const startY = _nodes[index - 1].y;
      ctx.beginPath();
      ctx.moveTo(startX, startY);
      ctx.lineTo(x, y);
      ctx.strokeStyle = '#696969';
      ctx.stroke();
    }
  });
  if (_nodes.length) {
    for (let i = 0; i < _nodes.length - 1; i++) {
      const arr = [{
        x: _nodes[i].x,
        y: _nodes[i].y,
      }, {
        x: _nodes[i + 1].x,
        y: _nodes[i + 1].y,
      }];
      next_nodes.push(bezier(arr, t));
    }
    drawnode(next_nodes);
  }
}

function drawBezier(ctx, origin_nodes) {
  if (t > 1) {
    isPrinting = false;
    return;
  }
  isPrinting = true;
  const nodes = origin_nodes;
  t += 0.01;
  ctx.clearRect(0, 0, elCanvas.width, elCanvas.height);
  drawnode(nodes);
  window.requestAnimationFrame(drawBezier.bind(this, ctx, nodes));
}

elCanvas.addEventListener('mousedown', (e) => {
  isDrag = true;
  clickon = new Date().getTime();
  const { target } = e;
  const diffLeft = target.getBoundingClientRect().left;
  const diffTop = target.getBoundingClientRect().top;
  const { clientX } = e;
  const { clientY } = e;
  const x = clientX - diffLeft;
  const y = clientY - diffTop;
  clickNodes.forEach((item, index) => {
    const absX = Math.abs(item.x - x);
    const absY = Math.abs(item.y - y);
    if (absX < 5 && absY < 5) {
      isDragNode = true;
      dragIndex = index;
    }
  });
});

elCanvas.addEventListener('mousemove', (e) => {
  if (isDrag && isDragNode) {
    const { target } = e;
    const diffLeft = target.getBoundingClientRect().left;
    const diffTop = target.getBoundingClientRect().top;
    const { clientX } = e;
    const { clientY } = e;
    const x = clientX - diffLeft;
    const y = clientY - diffTop;
    clickNodes[dragIndex] = {
      x,
      y,
    };
    ctx.clearRect(0, 0, elCanvas.width, elCanvas.height);
    clickNodes.forEach((item, index) => {
      const { x } = item;
      const { y } = item;
      const i = parseInt(index, 10) + 1;
      let startX;
      let startY;
      ctx.fillText(`p${i}`, x, y + 20);
      ctx.fillText(`p${i}: (${x}, ${y})`, 10, i * 20);
      ctx.beginPath();
      ctx.arc(x, y, 4, 0, Math.PI * 2, false);
      ctx.fill();
      ctx.beginPath();
      ctx.moveTo(startX, startY);
      ctx.lineTo(x, y);
      ctx.strokeStyle = '#696969';
      ctx.stroke();
      if (index) {
        startX = clickNodes[index - 1].x;
        startY = clickNodes[index - 1].y;
        ctx.beginPath();
        ctx.moveTo(startX, startY);
        ctx.lineTo(x, y);
        ctx.stroke();
      }
    });
    if (isPrinted) {
      const bezierArr = [];
      for (let i = 0; i < 1; i += 0.01) {
        bezierArr.push(bezier(clickNodes, i));
      }
      bezierArr.forEach((obj, index) => {
        if (index) {
          const startX = bezierArr[index - 1].x;
          const startY = bezierArr[index - 1].y;
          const { x } = obj;
          const { y } = obj;
          ctx.beginPath();
          ctx.moveTo(startX, startY);
          ctx.lineTo(x, y);
          ctx.strokeStyle = 'red';
          ctx.stroke();
        }
      });
    }
  }
});

elCanvas.addEventListener('mouseup', (e) => {
  isDrag = false;
  isDragNode = false;
  clickoff = new Date().getTime();
  if (clickoff - clickon < 200) {
    const { target } = e;
    const diffLeft = target.getBoundingClientRect().left;
    const diffTop = target.getBoundingClientRect().top;
    const { clientX } = e;
    const { clientY } = e;
    const x = clientX - diffLeft;
    const y = clientY - diffTop;
    if (!isPrinted && !isDragNode) {
      num++;
      // const ctx = elCanvas.getContext('2d');
      ctx.font = '16px Microsoft YaHei';
      ctx.fillStyle = '#696969';
      ctx.fillText(`p${num}`, x, y + 20);
      ctx.fillText(`p${num}: (${x / SIZE}, ${y / SIZE})`, 10, num * 20);
      ctx.beginPath();
      ctx.arc(x, y, 4, 0, Math.PI * 2, false);
      ctx.fill();
      if (clickNodes.length) {
        const startX = clickNodes[clickNodes.length - 1].x;
        const startY = clickNodes[clickNodes.length - 1].y;
        ctx.beginPath();
        ctx.moveTo(startX, startY);
        ctx.lineTo(x, y);
        ctx.strokeStyle = '#696969';
        ctx.stroke();
      }
      clickNodes.push({
        x,
        y,
      });
    }
  }
});

elPrintBtn.addEventListener('click', () => {
  if (!num) return;

  if (isPrinting) {
    return;
  }

  isPrinted = true;
  drawBezier(ctx, clickNodes);
});

elClearBtn.addEventListener('click', () => {
  if (isPrinting) {
    return;
  }

  isPrinted = false;
  ctx.clearRect(0, 0, elCanvas.width, elCanvas.height);
  clickNodes = [];
  bezierNodes = [];
  t = 0;
  num = 0;
});
