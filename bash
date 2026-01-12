<!DOCTYPE html>
<html lang="sq">
<head>
<meta charset="UTF-8">
<title>Snake Full Retro Nokia</title>
<style>
body {
    display:flex;
    flex-direction:column;
    justify-content:center;
    align-items:center;
    height:100vh;
    background:#111;
    margin:0;
    font-family: monospace;
}
#game-container {
    display:flex;
    flex-direction:column;
    align-items:center;
}
canvas {
    background:#a0ffa0;
    border:4px solid #006400;
}
#tacho {
    margin-top:5px;
    color:#004400;
    font-size:14px;
}
#controls {
    margin-top:5px;
    display:flex;
    flex-direction:column;
    align-items:center;
}
.row {
    display:flex;
}
button {
    width:40px;
    height:40px;
    margin:2px;
    font-size:18px;
    font-weight:bold;
    border-radius:4px;
    border:none;
    background:#006400;
    color:#a0ffa0;
}
</style>
</head>
<body>
<div id="game-container">
    <canvas id="game" width="200" height="200"></canvas>
    <div id="tacho">Score: 0 | Speed: 1</div>
    <div id="controls">
        <div class="row"><button id="up">↑</button></div>
        <div class="row">
            <button id="left">←</button>
            <button id="down">↓</button>
            <button id="right">→</button>
        </div>
    </div>
</div>

<script>
// Tingulli beep për ushqim dhe crash për përplasje
const beep = new Audio();
beep.src = "data:audio/wav;base64,UklGRiQAAABXQVZFZm10IBAAAAABAAEAQB8AAIA+AAACABAAZGF0YQAAAAA=";

const crash = new Audio();
crash.src = "data:audio/wav;base64,UklGRjQAAABXQVZFZm10IBAAAAABAAEAQB8AAIA+AAACABAAZGF0YYAAAAA=";

const canvas = document.getElementById('game');
const ctx = canvas.getContext('2d');
const tacho = document.getElementById('tacho');

const box = 10;
let snake = [{x:10*box, y:10*box}];
let food = {x: Math.floor(Math.random()*20)*box, y: Math.floor(Math.random()*20)*box};
let d;
let score = 0;
let speed = 150;
let game;

// Touch arrows
document.getElementById('up').addEventListener('click',()=>{ if(d!=='DOWN') d='UP'; });
document.getElementById('down').addEventListener('click',()=>{ if(d!=='UP') d='DOWN'; });
document.getElementById('left').addEventListener('click',()=>{ if(d!=='RIGHT') d='LEFT'; });
document.getElementById('right').addEventListener('click',()=>{ if(d!=='LEFT') d='RIGHT'; });

// Arrow keys
document.addEventListener('keydown', e => {
    if(e.key==='ArrowLeft' && d!=='RIGHT') d='LEFT';
    if(e.key==='ArrowUp' && d!=='DOWN') d='UP';
    if(e.key==='ArrowRight' && d!=='LEFT') d='RIGHT';
    if(e.key==='ArrowDown' && d!=='UP') d='DOWN';
});

function collision(head,array){ return array.some(s=>s.x===head.x && s.y===head.y); }

function updateTacho(){
    let t = Math.round(200/speed);
    tacho.textContent = `Score: ${score} | Speed: ${t}`;
}

function draw(){
    ctx.fillStyle = '#a0ffa0';
    ctx.fillRect(0,0,canvas.width,canvas.height);

    // snake pixel style
    snake.forEach((s,i)=>{
        ctx.fillStyle = i===0 ? '#004400':'#006400';
        ctx.fillRect(s.x, s.y, box, box);
    });

    // food pixel
    ctx.fillStyle = '#ff0000';
    ctx.fillRect(food.x, food.y, box, box);

    let head = {...snake[0]};
    if(d==='LEFT') head.x -= box;
    if(d==='UP') head.y -= box;
    if(d==='RIGHT') head.x += box;
    if(d==='DOWN') head.y += box;

    // eat food
    if(head.x===food.x && head.y===food.y){
        score++;
        beep.play();
        food = {x: Math.floor(Math.random()*20)*box, y: Math.floor(Math.random()*20)*box};
        speed = Math.max(50, speed-5);
        clearInterval(game);
        game = setInterval(draw,speed);
        updateTacho();
    } else { snake.pop(); }

    // collision
    if(head.x<0||head.x>=canvas.width||head.y<0||head.y>=canvas.height||collision(head,snake)){
        crash.play();
        alert('Loja mbaroi! Score: '+score);
        snake=[{x:10*box,y:10*box}];
        score=0;
        speed=150;
        d=null;
        clearInterval(game);
        game = setInterval(draw,speed);
        updateTacho();
    }

    snake.unshift(head);
    updateTacho();
}

game = setInterval(draw,speed);
</script>
</body>
</html>