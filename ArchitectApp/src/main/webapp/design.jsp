<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ArchStudio — 3D Architecture Designer</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
:root {
  --bg:       #0f1117;
  --panel:    #161b27;
  --panel2:   #1e2535;
  --border:   #2a3347;
  --accent:   #4f8ef7;
  --accent2:  #f7964f;
  --green:    #3dd68c;
  --red:      #f74f4f;
  --text:     #e2e8f0;
  --muted:    #64748b;
  --light:    #94a3b8;
  --radius:   8px;
}
*{margin:0;padding:0;box-sizing:border-box;}
body{
  background:var(--bg); color:var(--text);
  font-family:'DM Sans',sans-serif; font-size:13px;
  height:100vh; overflow:hidden; display:flex; flex-direction:column;
}

/* ── TOP BAR ── */
#topbar{
  height:48px; background:var(--panel); border-bottom:1px solid var(--border);
  display:flex; align-items:center; padding:0 16px; gap:16px; flex-shrink:0;
  z-index:10;
}
.logo{
  font-family:'DM Mono',monospace; font-size:15px; font-weight:500;
  color:var(--accent); letter-spacing:1px; white-space:nowrap;
}
.logo span{color:var(--accent2);}
#projectName{
  background:transparent; border:1px solid transparent; color:var(--text);
  font-family:'DM Sans',sans-serif; font-size:13px; padding:4px 8px;
  border-radius:4px; width:180px; transition:.2s;
}
#projectName:focus{ border-color:var(--accent); outline:none; background:var(--panel2); }
.topbar-sep{ flex:1; }
.top-btn{
  padding:6px 14px; border-radius:var(--radius); border:1px solid var(--border);
  background:var(--panel2); color:var(--light); cursor:pointer; font-size:12px;
  transition:.15s; font-family:'DM Sans',sans-serif; white-space:nowrap;
}
.top-btn:hover{ background:var(--accent); color:#fff; border-color:var(--accent); }
.top-btn.danger:hover{ background:var(--red); border-color:var(--red); }
#statsRow{ display:flex; gap:16px; font-size:11px; color:var(--muted); font-family:'DM Mono',monospace; }
.stat-item b{ color:var(--accent2); }

/* ── MAIN LAYOUT ── */
#main{ display:flex; flex:1; overflow:hidden; }

/* ── LEFT PANEL ── */
#leftPanel{
  width:220px; background:var(--panel); border-right:1px solid var(--border);
  display:flex; flex-direction:column; overflow-y:auto; flex-shrink:0;
}
.panel-section{ padding:12px; border-bottom:1px solid var(--border); }
.panel-title{
  font-size:10px; font-weight:600; color:var(--muted); letter-spacing:1.5px;
  text-transform:uppercase; margin-bottom:8px;
}

/* Tool buttons */
.tool-grid{ display:grid; grid-template-columns:1fr 1fr; gap:6px; }
.tool-btn{
  padding:8px 6px; background:var(--panel2); border:1px solid var(--border);
  border-radius:var(--radius); cursor:pointer; text-align:center;
  transition:.15s; color:var(--light); font-size:11px; line-height:1.4;
}
.tool-btn:hover{ border-color:var(--accent); color:var(--accent); }
.tool-btn.active{ background:var(--accent); color:#fff; border-color:var(--accent); }
.tool-btn .icon{ font-size:18px; display:block; margin-bottom:3px; }

/* Material picker */
.mat-grid{ display:grid; grid-template-columns:repeat(3,1fr); gap:5px; }
.mat-btn{
  padding:5px; border-radius:5px; border:1px solid var(--border);
  cursor:pointer; text-align:center; font-size:10px; color:var(--muted);
  background:var(--panel2); transition:.15s;
}
.mat-btn:hover,.mat-btn.active{ border-color:var(--accent); color:var(--accent); }

/* Color picker */
.color-row{ display:flex; flex-wrap:wrap; gap:5px; }
.color-swatch{
  width:24px; height:24px; border-radius:4px; border:2px solid transparent;
  cursor:pointer; transition:.1s;
}
.color-swatch.active, .color-swatch:hover{ border-color:#fff; transform:scale(1.15); }
#customColor{ width:36px; height:24px; border:none; border-radius:4px; cursor:pointer; padding:0; }

/* Size controls */
.size-row{ display:flex; align-items:center; gap:6px; margin-bottom:5px; }
.size-label{ width:50px; color:var(--muted); font-size:11px; }
.size-input{
  flex:1; background:var(--panel2); border:1px solid var(--border);
  color:var(--text); border-radius:4px; padding:3px 6px; font-size:11px;
  font-family:'DM Mono',monospace;
}
.size-input:focus{ outline:none; border-color:var(--accent); }

/* ── CANVAS AREA ── */
#canvasWrap{ flex:1; position:relative; overflow:hidden; }
#canvas{ display:block; width:100%; height:100%; }

/* View toggle */
#viewToggle{
  position:absolute; top:12px; left:12px;
  display:flex; gap:4px;
}
.view-btn{
  padding:6px 14px; background:rgba(22,27,39,0.9); border:1px solid var(--border);
  color:var(--light); border-radius:var(--radius); cursor:pointer; font-size:11px;
  transition:.15s; backdrop-filter:blur(4px);
}
.view-btn.active{ background:var(--accent); color:#fff; border-color:var(--accent); }

/* Camera controls hint */
#camHint{
  position:absolute; bottom:12px; left:12px;
  background:rgba(22,27,39,0.85); border:1px solid var(--border);
  padding:8px 12px; border-radius:var(--radius); font-size:10px;
  color:var(--muted); line-height:1.8; backdrop-filter:blur(4px);
}
#camHint b{ color:var(--accent); }

/* Grid overlay info */
#placingHint{
  position:absolute; top:12px; right:12px;
  background:rgba(79,142,247,0.15); border:1px solid var(--accent);
  color:var(--accent); padding:8px 14px; border-radius:var(--radius);
  font-size:11px; display:none; backdrop-filter:blur(4px);
}

/* ── RIGHT PANEL (properties) ── */
#rightPanel{
  width:200px; background:var(--panel); border-left:1px solid var(--border);
  display:flex; flex-direction:column; overflow-y:auto; flex-shrink:0;
}
#propTitle{
  font-size:10px; font-weight:600; color:var(--muted); letter-spacing:1.5px;
  text-transform:uppercase; padding:12px 12px 6px;
  border-bottom:1px solid var(--border);
}
#propList{ padding:10px 12px; flex:1; }
.prop-row{ margin-bottom:10px; }
.prop-label{ font-size:10px; color:var(--muted); margin-bottom:3px; }
.prop-val{
  width:100%; background:var(--panel2); border:1px solid var(--border);
  color:var(--text); border-radius:4px; padding:4px 7px; font-size:11px;
  font-family:'DM Mono',monospace;
}
.prop-val:focus{ outline:none; border-color:var(--accent); }
.prop-color{ width:100%; height:28px; border:1px solid var(--border); border-radius:4px; cursor:pointer; }
.del-btn{
  width:100%; padding:7px; background:transparent; border:1px solid var(--red);
  color:var(--red); border-radius:var(--radius); cursor:pointer; font-size:11px;
  margin-top:10px; transition:.15s;
}
.del-btn:hover{ background:var(--red); color:#fff; }
#noSelection{ color:var(--muted); font-size:11px; padding:12px; line-height:1.7; }

/* Element list */
#elemList{ padding:0 12px 12px; }
.elem-item{
  padding:6px 8px; border-radius:5px; cursor:pointer; display:flex;
  align-items:center; gap:6px; margin-bottom:3px; transition:.1s;
  border:1px solid transparent;
}
.elem-item:hover{ background:var(--panel2); }
.elem-item.selected{ background:rgba(79,142,247,0.15); border-color:var(--accent); }
.elem-dot{ width:8px; height:8px; border-radius:2px; flex-shrink:0; }
.elem-name{ font-size:11px; color:var(--light); flex:1; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.elem-type{ font-size:9px; color:var(--muted); font-family:'DM Mono',monospace; }

/* Toast */
#toast{
  position:fixed; bottom:20px; left:50%; transform:translateX(-50%) translateY(60px);
  background:var(--panel2); border:1px solid var(--border); color:var(--text);
  padding:8px 20px; border-radius:20px; font-size:12px; transition:.3s;
  z-index:100; pointer-events:none; opacity:0;
}
#toast.show{ transform:translateX(-50%) translateY(0); opacity:1; }
</style>
</head>
<body>

<!-- TOP BAR -->
<div id="topbar">
  <div class="logo">Arch<span>Studio</span></div>
  <input type="text" id="projectName" value="My Design" placeholder="Project name" title="Click to rename">
  <div class="topbar-sep"></div>
  <div id="statsRow">
    <span>Walls: <b id="sWalls">0</b></span>
    <span>Floors: <b id="sFloors">0</b></span>
    <span>Objects: <b id="sObjs">0</b></span>
    <span>Total: <b id="sTotal">0</b></span>
  </div>
  <% if (session.getAttribute("userId") != null) { %>
    <button class="top-btn" onclick="saveDesign()" style="background:var(--accent); color:#fff; border-color:var(--accent);">☁ Save</button>
    <a href="dashboard.jsp" class="top-btn" style="text-decoration:none; display:flex; align-items:center;">Dashboard</a>
  <% } else { %>
    <a href="login.jsp" class="top-btn" style="text-decoration:none; display:flex; align-items:center;">Login to Save</a>
  <% } %>
  <button class="top-btn" onclick="exportDesign()">💾 Export JSON</button>
  <button class="top-btn danger" onclick="clearAll()">🗑 Clear All</button>
</div>

<!-- MAIN -->
<div id="main">

  <!-- LEFT PANEL -->
  <div id="leftPanel">

    <!-- Elements to place -->
    <div class="panel-section">
      <div class="panel-title">Structure</div>
      <div class="tool-grid">
        <div class="tool-btn active" data-type="WALL"   onclick="setTool(this,'WALL')">  <span class="icon">🧱</span>Wall</div>
        <div class="tool-btn" data-type="FLOOR"  onclick="setTool(this,'FLOOR')"> <span class="icon">⬜</span>Floor</div>
        <div class="tool-btn" data-type="ROOF"   onclick="setTool(this,'ROOF')">  <span class="icon">🏠</span>Roof</div>
        <div class="tool-btn" data-type="STAIR"  onclick="setTool(this,'STAIR')"> <span class="icon">🪜</span>Stair</div>
        <div class="tool-btn" data-type="DOOR"   onclick="setTool(this,'DOOR')">  <span class="icon">🚪</span>Door</div>
        <div class="tool-btn" data-type="WINDOW" onclick="setTool(this,'WINDOW')"><span class="icon">🪟</span>Window</div>
      </div>
    </div>

    <div class="panel-section">
      <div class="panel-title">Furniture</div>
      <div class="tool-grid">
        <div class="tool-btn" data-type="FURN_SOFA"  onclick="setTool(this,'FURN_SOFA')"> <span class="icon">🛋</span>Sofa</div>
        <div class="tool-btn" data-type="FURN_TABLE" onclick="setTool(this,'FURN_TABLE')"><span class="icon">🪑</span>Table</div>
        <div class="tool-btn" data-type="FURN_BED"   onclick="setTool(this,'FURN_BED')">  <span class="icon">🛏</span>Bed</div>
        <div class="tool-btn" data-type="FURN_BATH"  onclick="setTool(this,'FURN_BATH')"> <span class="icon">🛁</span>Bath</div>
        <div class="tool-btn" data-type="FURN_DESK"  onclick="setTool(this,'FURN_DESK')"> <span class="icon">🖥</span>Desk</div>
        <div class="tool-btn" data-type="FURN_PLANT" onclick="setTool(this,'FURN_PLANT')"><span class="icon">🪴</span>Plant</div>
      </div>
    </div>

    <!-- Material -->
    <div class="panel-section">
      <div class="panel-title">Material</div>
      <div class="mat-grid">
        <div class="mat-btn active" data-mat="CONCRETE" onclick="setMat(this,'CONCRETE')">Concrete</div>
        <div class="mat-btn" data-mat="WOOD"     onclick="setMat(this,'WOOD')">Wood</div>
        <div class="mat-btn" data-mat="GLASS"    onclick="setMat(this,'GLASS')">Glass</div>
        <div class="mat-btn" data-mat="BRICK"    onclick="setMat(this,'BRICK')">Brick</div>
        <div class="mat-btn" data-mat="MARBLE"   onclick="setMat(this,'MARBLE')">Marble</div>
        <div class="mat-btn" data-mat="METAL"    onclick="setMat(this,'METAL')">Metal</div>
      </div>
    </div>

    <!-- Color -->
    <div class="panel-section">
      <div class="panel-title">Color</div>
      <div class="color-row" id="colorRow">
        <div class="color-swatch active" style="background:#e8e0d0" data-c="#e8e0d0" onclick="setColor(this,'#e8e0d0')"></div>
        <div class="color-swatch" style="background:#c8b99a" data-c="#c8b99a" onclick="setColor(this,'#c8b99a')"></div>
        <div class="color-swatch" style="background:#7a7a7a" data-c="#7a7a7a" onclick="setColor(this,'#7a7a7a')"></div>
        <div class="color-swatch" style="background:#a0522d" data-c="#a0522d" onclick="setColor(this,'#a0522d')"></div>
        <div class="color-swatch" style="background:#add8e6" data-c="#add8e6" onclick="setColor(this,'#add8e6')"></div>
        <div class="color-swatch" style="background:#3dd68c" data-c="#3dd68c" onclick="setColor(this,'#3dd68c')"></div>
        <div class="color-swatch" style="background:#f7964f" data-c="#f7964f" onclick="setColor(this,'#f7964f')"></div>
        <div class="color-swatch" style="background:#4f8ef7" data-c="#4f8ef7" onclick="setColor(this,'#4f8ef7')"></div>
        <input type="color" id="customColor" value="#ffffff" title="Custom color" onchange="setCustomColor(this.value)">
      </div>
    </div>

    <!-- Size -->
    <div class="panel-section">
      <div class="panel-title">Dimensions</div>
      <div class="size-row"><span class="size-label">Width</span>  <input class="size-input" id="sWidth"  type="number" value="1"   step="0.5" min="0.1"></div>
      <div class="size-row"><span class="size-label">Height</span> <input class="size-input" id="sHeight" type="number" value="3"   step="0.5" min="0.1"></div>
      <div class="size-row"><span class="size-label">Depth</span>  <input class="size-input" id="sDepth"  type="number" value="0.3" step="0.1" min="0.1"></div>
      <div class="size-row"><span class="size-label">Rotate°</span><input class="size-input" id="sRotY"   type="number" value="0"   step="45"  min="0" max="360"></div>
    </div>

    <!-- Mode -->
    <div class="panel-section">
      <div class="panel-title">Mode</div>
      <div class="tool-grid">
        <div class="tool-btn active" id="modePlace"  onclick="setMode('place')"> <span class="icon">✏️</span>Place</div>
        <div class="tool-btn"        id="modeSelect" onclick="setMode('select')"><span class="icon">🖱</span>Select</div>
      </div>
    </div>

  </div>

  <!-- 3D CANVAS -->
  <div id="canvasWrap">
    <canvas id="canvas"></canvas>

    <div id="viewToggle">
      <button class="view-btn active" onclick="setView('3d')">3D</button>
      <button class="view-btn"        onclick="setView('top')">Top</button>
      <button class="view-btn"        onclick="setView('front')">Front</button>
    </div>

    <div id="placingHint">✏️ Click on grid to place element</div>

    <div id="camHint">
      <b>Left drag</b> Orbit &nbsp; <b>Right drag</b> Pan<br>
      <b>Scroll</b> Zoom &nbsp; <b>Click</b> Select/Place
    </div>
  </div>

  <!-- RIGHT PANEL -->
  <div id="rightPanel">
    <div id="propTitle">Properties</div>
    <div id="propList">
      <div id="noSelection">Click an element to select it and edit its properties.</div>
      <div id="propForm" style="display:none">
        <div class="prop-row"><div class="prop-label">Label</div>    <input class="prop-val" id="pLabel"  type="text"></div>
        <div class="prop-row"><div class="prop-label">X Position</div><input class="prop-val" id="pX"     type="number" step="0.5"></div>
        <div class="prop-row"><div class="prop-label">Y Position</div><input class="prop-val" id="pY"     type="number" step="0.5"></div>
        <div class="prop-row"><div class="prop-label">Z Position</div><input class="prop-val" id="pZ"     type="number" step="0.5"></div>
        <div class="prop-row"><div class="prop-label">Width</div>    <input class="prop-val" id="pWidth"  type="number" step="0.5"></div>
        <div class="prop-row"><div class="prop-label">Height</div>   <input class="prop-val" id="pHeight" type="number" step="0.5"></div>
        <div class="prop-row"><div class="prop-label">Depth</div>    <input class="prop-val" id="pDepth"  type="number" step="0.5"></div>
        <div class="prop-row"><div class="prop-label">Rotation°</div><input class="prop-val" id="pRotY"   type="number" step="45"></div>
        <div class="prop-row"><div class="prop-label">Color</div>    <input class="prop-color" id="pColor" type="color"></div>
        <button class="del-btn" onclick="deleteSelected()">🗑 Delete Element</button>
      </div>
    </div>
    <div style="border-top:1px solid var(--border); padding:10px 12px;">
      <div class="panel-title">Elements (<span id="elemCount">0</span>)</div>
      <div id="elemList"></div>
    </div>
  </div>
</div>

<div id="toast"></div>

<!-- Three.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script>
// =====================================================================
//  ArchStudio — 3D Architecture Designer
//  Java Servlet backend (stores project in HttpSession)
//  Three.js frontend (3D rendering + interaction)
// =====================================================================

const SERVLET = '<%= request.getContextPath() %>/design';

// ---- Scene setup ---------------------------------------------------
const canvas   = document.getElementById('canvas');
const wrap     = document.getElementById('canvasWrap');
const renderer = new THREE.WebGLRenderer({ canvas, antialias:true });
renderer.setPixelRatio(window.devicePixelRatio);
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap;
renderer.setClearColor(0x1a2035, 1);

const scene  = new THREE.Scene();
scene.fog    = new THREE.FogExp2(0x1a2035, 0.025);

const camera = new THREE.PerspectiveCamera(60, 1, 0.1, 200);
camera.position.set(15, 18, 20);
camera.lookAt(0, 0, 0);

// ---- Lighting ------------------------------------------------------
const ambient = new THREE.AmbientLight(0x8899cc, 0.7);
scene.add(ambient);

const sun = new THREE.DirectionalLight(0xfff5e0, 1.3);
sun.position.set(20, 40, 20);
sun.castShadow = true;
sun.shadow.mapSize.set(2048, 2048);
sun.shadow.camera.near = 0.5;
sun.shadow.camera.far  = 100;
sun.shadow.camera.left = sun.shadow.camera.bottom = -30;
sun.shadow.camera.right = sun.shadow.camera.top   =  30;
scene.add(sun);

const fill = new THREE.DirectionalLight(0x4466aa, 0.4);
fill.position.set(-10, 5, -10);
scene.add(fill);

// ---- Grid ----------------------------------------------------------
const gridHelper = new THREE.GridHelper(40, 40, 0x2a3347, 0x1e2535);
scene.add(gridHelper);

// Ground plane (invisible, for raycasting)
const groundGeo = new THREE.PlaneGeometry(40, 40);
const groundMat = new THREE.MeshBasicMaterial({ visible:false, side:THREE.DoubleSide });
const ground    = new THREE.Mesh(groundGeo, groundMat);
ground.rotation.x = -Math.PI / 2;
ground.name = 'GROUND';
scene.add(ground);

// Ghost preview mesh
const ghostGeo = new THREE.BoxGeometry(1,1,1);
const ghostMat = new THREE.MeshBasicMaterial({ color:0x4f8ef7, transparent:true, opacity:0.35, depthWrite:false });
const ghost    = new THREE.Mesh(ghostGeo, ghostMat);
ghost.visible  = false;
scene.add(ghost);

// ---- State ---------------------------------------------------------
let currentTool  = 'WALL';
let currentMat   = 'CONCRETE';
let currentColor = '#e8e0d0';
let currentMode  = 'place';  // 'place' | 'select'
let selectedId   = null;
const meshMap    = {};        // id → THREE.Mesh
let projectData  = null;

// Dimension inputs
const gW = () => parseFloat(document.getElementById('sWidth').value)  || 1;
const gH = () => parseFloat(document.getElementById('sHeight').value) || 3;
const gD = () => parseFloat(document.getElementById('sDepth').value)  || 0.3;
const gR = () => parseFloat(document.getElementById('sRotY').value)   || 0;

// ---- Material → color map ------------------------------------------
const MAT_COLORS = {
  CONCRETE: '#d4cfc7', WOOD:'#c8a96e', GLASS:'#a8d8ea',
  BRICK:'#b5603f', MARBLE:'#f0ece4', METAL:'#8a9bb0'
};

// Default sizes per type
const TYPE_DEFAULTS = {
  WALL:       {w:4,   h:3,   d:0.3},
  FLOOR:      {w:5,   h:0.2, d:5},
  ROOF:       {w:5,   h:0.3, d:5},
  DOOR:       {w:1,   h:2.2, d:0.15},
  WINDOW:     {w:1.2, h:1.2, d:0.1},
  STAIR:      {w:2,   h:2,   d:3},
  FURN_SOFA:  {w:2.2, h:0.8, d:1},
  FURN_TABLE: {w:1.5, h:0.75,d:0.8},
  FURN_BED:   {w:2,   h:0.6, d:2.2},
  FURN_BATH:  {w:1.7, h:0.6, d:0.8},
  FURN_DESK:  {w:1.5, h:0.8, d:0.7},
  FURN_PLANT: {w:0.4, h:1.2, d:0.4},
};

// Type → display color
const TYPE_COLORS = {
  WALL:'#e8e0d0', FLOOR:'#c8b99a', ROOF:'#8a7a6a',
  DOOR:'#8b6914', WINDOW:'#add8e6', STAIR:'#a0908a',
  FURN_SOFA:'#6a8fa0', FURN_TABLE:'#b0905a',
  FURN_BED:'#9a8ab0',  FURN_BATH:'#a0c8d8',
  FURN_DESK:'#7a8a9a', FURN_PLANT:'#3a8a4a',
};

// ---- Build mesh from element data ----------------------------------
function buildMesh(el) {
  const geo = new THREE.BoxGeometry(el.width, el.height, el.depth);
  let color = el.color || '#e8e0d0';

  // Glass is transparent
  const isGlass = (el.material === 'GLASS' || el.type === 'WINDOW');
  const mat = new THREE.MeshLambertMaterial({
    color: new THREE.Color(color),
    transparent: isGlass,
    opacity: isGlass ? 0.45 : 1.0
  });

  const mesh = new THREE.Mesh(geo, mat);
  mesh.position.set(el.x, el.y + el.height / 2, el.z);
  mesh.rotation.y = THREE.MathUtils.degToRad(el.rotationY || 0);
  mesh.castShadow    = true;
  mesh.receiveShadow = true;
  mesh.userData.id   = el.id;
  mesh.userData.type = el.type;
  scene.add(mesh);
  meshMap[el.id] = mesh;
  return mesh;
}

function removeMesh(id) {
  if (meshMap[id]) { scene.remove(meshMap[id]); delete meshMap[id]; }
}

function rebuildScene(data) {
  // Remove all element meshes
  Object.keys(meshMap).forEach(id => removeMesh(id));
  data.elements.forEach(el => buildMesh(el));
  updateStats(data);
  updateElemList(data.elements);
}

// ---- AJAX helpers --------------------------------------------------
async function post(params) {
  const body = new URLSearchParams(params);
  const r    = await fetch(SERVLET, { method:'POST', body });
  return r.json();
}

async function getState() {
  const r = await fetch(SERVLET + '?action=state');
  return r.json();
}

// ---- Tool selection ------------------------------------------------
function setTool(btn, type) {
  document.querySelectorAll('.tool-btn[data-type]').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  currentTool = type;
  // Auto-set sensible defaults
  const def = TYPE_DEFAULTS[type] || {w:1,h:3,d:0.3};
  document.getElementById('sWidth').value  = def.w;
  document.getElementById('sHeight').value = def.h;
  document.getElementById('sDepth').value  = def.d;
  if (TYPE_COLORS[type]) setColorVal(TYPE_COLORS[type]);
}

function setMat(btn, mat) {
  document.querySelectorAll('.mat-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  currentMat = mat;
  if (MAT_COLORS[mat]) setColorVal(MAT_COLORS[mat]);
}

function setColor(swatch, color) {
  document.querySelectorAll('.color-swatch').forEach(s => s.classList.remove('active'));
  swatch.classList.add('active');
  currentColor = color;
}
function setCustomColor(color) {
  document.querySelectorAll('.color-swatch').forEach(s => s.classList.remove('active'));
  currentColor = color;
}
function setColorVal(color) {
  currentColor = color;
  document.querySelectorAll('.color-swatch').forEach(s => {
    s.classList.toggle('active', s.dataset.c === color);
  });
}

function setMode(mode) {
  currentMode = mode;
  document.getElementById('modePlace').classList.toggle('active',  mode === 'place');
  document.getElementById('modeSelect').classList.toggle('active', mode === 'select');
  document.getElementById('placingHint').style.display = mode === 'place' ? 'block' : 'none';
  ghost.visible = false;
}

// ---- Raycasting ----------------------------------------------------
const raycaster = new THREE.Raycaster();
const mouse2    = new THREE.Vector2();

function getMousePos(e) {
  const rect = canvas.getBoundingClientRect();
  mouse2.x = ((e.clientX - rect.left) / rect.width)  * 2 - 1;
  mouse2.y = -((e.clientY - rect.top)  / rect.height) * 2 + 1;
}

function raycastGround() {
  raycaster.setFromCamera(mouse2, camera);
  const targets = [ground, ...Object.values(meshMap)];
  const hits = raycaster.intersectObjects(targets);
  return hits.length > 0 ? hits[0].point : null;
}

function raycastMeshes() {
  raycaster.setFromCamera(mouse2, camera);
  const meshes = Object.values(meshMap);
  const hits = raycaster.intersectObjects(meshes);
  return hits.length > 0 ? hits[0].object : null;
}

// Snap to grid
function snap(v, step=0.5) { return Math.round(v / step) * step; }

// ---- Mouse events on canvas ----------------------------------------
canvas.addEventListener('mousemove', e => {
  if (isDragging) return;
  getMousePos(e);
  if (currentMode === 'place') {
    const pt = raycastGround();
    if (pt) {
      const w = gW(), h = gH(), d = gD();
      ghost.scale.set(w, h, d);
      // Let base Y snap to nearest 0.1, so objects sit firmly.
      const baseY = snap(pt.y, 0.1);
      ghost.position.set(snap(pt.x), baseY + h/2, snap(pt.z));
      ghost.rotation.y = THREE.MathUtils.degToRad(gR());
      ghost.visible = true;
    } else { ghost.visible = false; }
  }
});

canvas.addEventListener('mouseleave', () => { ghost.visible = false; });

canvas.addEventListener('click', async e => {
  if (isDragging) return;
  getMousePos(e);

  if (currentMode === 'place') {
    const pt = raycastGround();
    if (!pt) return;
    const w = gW(), h = gH(), d = gD(), r = gR();
    const baseY = snap(pt.y, 0.1);
    const data = await post({
      action:'add', type:currentTool,
      x: snap(pt.x), y: baseY, z: snap(pt.z),
      width:w, height:h, depth:d, rotY:r,
      color:currentColor, material:currentMat,
      label:currentTool
    });
    rebuildScene(data);
    toast('✅ ' + currentTool + ' placed');
  } else {
    // Select mode
    const hit = raycastMeshes();
    if (hit) {
      selectElement(hit.userData.id);
    } else {
      deselectElement();
    }
  }
});

canvas.addEventListener('contextmenu', e => e.preventDefault());

// ---- Selection & Properties ----------------------------------------
function selectElement(id) {
  selectedId = id;
  // Highlight
  Object.entries(meshMap).forEach(([k, m]) => {
    m.material.emissive = new THREE.Color(k === id ? 0x224488 : 0x000000);
  });
  // Find element data
  const el = projectData?.elements.find(e => e.id === id);
  if (el) showProps(el);
  updateElemList(projectData?.elements || []);
}

function deselectElement() {
  selectedId = null;
  Object.values(meshMap).forEach(m => m.material.emissive = new THREE.Color(0x000000));
  document.getElementById('noSelection').style.display = 'block';
  document.getElementById('propForm').style.display    = 'none';
  updateElemList(projectData?.elements || []);
}

function showProps(el) {
  document.getElementById('noSelection').style.display = 'none';
  document.getElementById('propForm').style.display    = 'block';
  document.getElementById('pLabel').value  = el.label;
  document.getElementById('pX').value      = el.x;
  document.getElementById('pY').value      = el.y;
  document.getElementById('pZ').value      = el.z;
  document.getElementById('pWidth').value  = el.width;
  document.getElementById('pHeight').value = el.height;
  document.getElementById('pDepth').value  = el.depth;
  document.getElementById('pRotY').value   = el.rotationY;
  document.getElementById('pColor').value  = el.color || '#ffffff';
}

// Property change → send to servlet → rebuild
async function updateProp(prop, val) {
  if (!selectedId) return;
  const data = await post({ action:'update', id:selectedId, prop, val });
  projectData = data;
  rebuildScene(data);
  // Re-select
  const el = data.elements.find(e => e.id === selectedId);
  if (el) { showProps(el); selectElement(selectedId); }
}

// Bind property inputs
['pLabel','pX','pY','pZ','pWidth','pHeight','pDepth','pRotY','pColor'].forEach(id => {
  const el = document.getElementById(id);
  const propMap = {pLabel:'label',pX:'x',pY:'y',pZ:'z',
    pWidth:'width',pHeight:'height',pDepth:'depth',pRotY:'rotationY',pColor:'color'};
  el.addEventListener('change', () => updateProp(propMap[id], el.value));
});

async function deleteSelected() {
  if (!selectedId) return;
  const data = await post({ action:'remove', id:selectedId });
  projectData = data;
  deselectElement();
  rebuildScene(data);
  toast('🗑 Element deleted');
}

// ---- Element list --------------------------------------------------
function updateElemList(elements) {
  const list = document.getElementById('elemList');
  list.innerHTML = '';
  elements.forEach(el => {
    const div = document.createElement('div');
    div.className = 'elem-item' + (el.id === selectedId ? ' selected' : '');
    div.innerHTML = `
      <div class="elem-dot" style="background:${el.color||'#888'}"></div>
      <div>
        <div class="elem-name">${el.label || el.type}</div>
        <div class="elem-type">${el.type}</div>
      </div>`;
    div.onclick = () => { setMode('select'); selectElement(el.id); };
    list.appendChild(div);
  });
  document.getElementById('elemCount').textContent = elements.length;
}

// ---- Stats ---------------------------------------------------------
function updateStats(data) {
  document.getElementById('sWalls').textContent  = data.totalWalls    || 0;
  document.getElementById('sFloors').textContent = data.totalFloors   || 0;
  document.getElementById('sObjs').textContent   = data.totalFurniture|| 0;
  document.getElementById('sTotal').textContent  = data.elementCount  || 0;
}

// ---- View presets --------------------------------------------------
function setView(v) {
  document.querySelectorAll('.view-btn').forEach(b => b.classList.remove('active'));
  event.target.classList.add('active');
  if      (v === '3d')    { camera.position.set(15,18,20); camera.lookAt(0,0,0); }
  else if (v === 'top')   { camera.position.set(0,30,0.01); camera.lookAt(0,0,0); }
  else if (v === 'front') { camera.position.set(0,8,25); camera.lookAt(0,4,0); }
}

// ---- Project name --------------------------------------------------
document.getElementById('projectName').addEventListener('change', async e => {
  await post({ action:'rename', name:e.target.value });
  toast('✅ Project renamed');
});

// ---- Clear all -----------------------------------------------------
async function clearAll() {
  if (!confirm('Clear all elements and start fresh?')) return;
  const data = await post({ action:'clear' });
  projectData = data;
  deselectElement();
  rebuildScene(data);
  toast('🗑 Canvas cleared');
}

// ---- Export JSON ---------------------------------------------------
function exportDesign() {
  const json = JSON.stringify(projectData, null, 2);
  const blob = new Blob([json], { type:'application/json' });
  const a    = document.createElement('a');
  a.href     = URL.createObjectURL(blob);
  a.download = (document.getElementById('projectName').value || 'design') + '.json';
  a.click();
  toast('💾 Design exported!');
}

async function saveDesign() {
  toast('☁ Saving...');
  const data = await fetch(SERVLET + '?action=save', { method:'POST' }).then(r=>r.json());
  if (data.status === 'saved') {
      toast('✅ Design saved to cloud!');
  } else {
      toast('❌ Error: ' + (data.message || 'Could not save'));
  }
}

// ---- Toast ---------------------------------------------------------
function toast(msg) {
  const el = document.getElementById('toast');
  el.textContent = msg;
  el.classList.add('show');
  clearTimeout(el._t);
  el._t = setTimeout(() => el.classList.remove('show'), 2200);
}

// ---- Orbit camera (mouse drag) -------------------------------------
let isDragging = false, isRightDrag = false;
let lastMX = 0, lastMY = 0;
const spherical = new THREE.Spherical().setFromVector3(
  camera.position.clone().sub(new THREE.Vector3(0,0,0))
);
const target = new THREE.Vector3(0, 2, 0);

canvas.addEventListener('mousedown', e => {
  isDragging  = true;
  isRightDrag = e.button === 2;
  lastMX = e.clientX; lastMY = e.clientY;
});
window.addEventListener('mouseup', () => { isDragging = false; });
window.addEventListener('mousemove', e => {
  if (!isDragging) return;
  const dx = e.clientX - lastMX, dy = e.clientY - lastMY;
  lastMX = e.clientX; lastMY = e.clientY;
  if (isRightDrag) {
    // Pan
    const panSpeed = 0.02;
    const right = new THREE.Vector3().crossVectors(
      camera.getWorldDirection(new THREE.Vector3()), camera.up
    ).normalize();
    target.addScaledVector(right, -dx * panSpeed);
    target.y += dy * panSpeed;
  } else {
    // Orbit
    spherical.theta -= dx * 0.008;
    spherical.phi   -= dy * 0.008;
    spherical.phi    = Math.max(0.1, Math.min(Math.PI/2 - 0.05, spherical.phi));
  }
  updateCamera();
});
canvas.addEventListener('wheel', e => {
  spherical.radius = Math.max(3, Math.min(60, spherical.radius + e.deltaY * 0.03));
  updateCamera();
}, { passive:true });

function updateCamera() {
  camera.position.setFromSpherical(spherical).add(target);
  camera.lookAt(target);
}

// ---- Resize --------------------------------------------------------
function resize() {
  const w = wrap.clientWidth, h = wrap.clientHeight;
  renderer.setSize(w, h);
  camera.aspect = w / h;
  camera.updateProjectionMatrix();
}
window.addEventListener('resize', resize);
resize();

// ---- Render loop ---------------------------------------------------
function animate() {
  requestAnimationFrame(animate);
  renderer.render(scene, camera);
}

// ---- Init ----------------------------------------------------------
async function init() {
  const params = new URLSearchParams(window.location.search);
  const loadId = params.get('load');
  
  let data;
  if (loadId) {
      const res = await fetch(SERVLET + '?action=load', {
          method: 'POST',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: 'id=' + loadId
      });
      data = await res.json();
      
      // We must also tell the server to replace the current Session state with this loaded project
      // so subsequent "add" / "delete" commands modify this project properly.
      await post({ action:'clear' }); // reset base
      await post({ action:'rename', name: data.name }); // set name
      for (const el of data.elements) {
          await post({
             action:'add', type:el.type, x:el.x, y:el.y, z:el.z, 
             width:el.width, height:el.height, depth:el.depth, 
             rotY:el.rotationY, color:el.color, material:el.material, label:el.label 
          });
      }
      
      // Re-fetch final unified server state
      data = await getState();
  } else {
      data = await getState();
  }

  projectData = data;
  rebuildScene(data);
  document.getElementById('projectName').value = data.name || 'My Design';
  animate();
  toast('🏗 Welcome to ArchStudio!');
}

init();
</script>
</body>
</html>
