/*var voronoi =  new Voronoi();
var sites = generateBeeHivePoints(view.size / 50, true);
var speeds = generateSpeeds(view.size / 50);
var forces = generateSpeeds(view.size / 50);
var bbox, diagram;
var oldSize = view.size;
var spotColor = new Color('rgba(240, 84, 76, 0.66)');
var mousePos = view.center;
var selected = false;

onResize();

function onMouseDown(event) {
    sites.push(event.point);
    renderDiagram();
}

function onMouseMove(event) {
    mousePos = event.point;
    mousePos.speed = new Point(0.0);
    mousePos.force = new Point(0.0);
    if (event.count == 0)
    {
        sites.push(mousePos);
        speeds.push(new Point(0,0));
        forces.push(new Point(0,0));
    }

    sites[sites.length - 1] = mousePos;
    speeds[speeds.length - 1] = new Point(0,0);
    forces[forces.length - 1] = new Point(0,0);
    renderDiagram();
}

function moveSites() {
  for (var i = 0; i < sites.length; i++) {
    sites[i] += speeds[i];
    speeds[i] += forces[i];
    sites[i].force = (Point.random() - new Point(0.5, 0.5)) * 100;
  }
}

function renderDiagram() {
    project.activeLayer.children = [];
    moveSites();
    var diagram = voronoi.compute(sites, bbox);
    if (diagram) {
        for (var i = 0, l = sites.length; i < l; i++) {
            var cell = diagram.cells[sites[i].voronoiId];
            if (cell) {
                var halfedges = cell.halfedges,
                    length = halfedges.length;
                if (length > 2) {
                    var points = [];
                    for (var j = 0; j < length; j++) {
                        v = halfedges[j].getEndpoint();
                        points.push(new Point(v));
                    }
                    createPath(points, sites[i]);
                }
            }
        }
    }
}

function removeSmallBits(path) {
    var averageLength = path.length / path.segments.length;
    var min = path.length / 50;
    for(var i = path.segments.length - 1; i >= 0; i--) {
        var segment = path.segments[i];
        var cur = segment.point;
        var nextSegment = segment.next;
        var next = nextSegment.point + nextSegment.handleIn;
        if (cur.getDistance(next) < min) {
            segment.remove();
        }
    }
}

function generateBeeHivePoints(size, loose) {
    var points = [];
    var col = view.size / size;
    for(var i = -1; i < size.width + 1; i++) {
        for(var j = -1; j < size.height + 1; j++) {
            var point = new Point(i, j) / new Point(size) * view.size + col / 2;
            if(j % 2)
                point += new Point(col.width / 2, 0);
            if(loose)
                point += (col) * Point.random() - col / 4;
            //point.speed = new Point(0, 0);
            //point.force = new Point(0, 0);
            points.push(point);
        }
    }
    return points;
}

function generateSpeeds(size)
{
  var points = [];
    for(var i = -1; i < size.width + 1; i++) {
        for(var j = -1; j < size.height + 1; j++) {
            var speed = new Point(0, 0);
            points.push(speed);
        }
    }
    return points;
}

function createPath(points, center) {
    var path = new Path();
    if (!selected) { 
        path.strokeColor = spotColor;
    } else {
        path.fullySelected = selected;
    }
    path.closed = true;

    for (var i = 0, l = points.length; i < l; i++) {
        var point = points[i];
        var next = points[(i + 1) == points.length ? 0 : i + 1];
        var vector = (next - point) / 2;
        path.add({
            point: point + vector,
            handleIn: -vector,
            handleOut: vector
        });
    }
    path.scale(0.95);
    removeSmallBits(path);
    return path;
}

function onResize() {
    var margin = 5;
    bbox = {
        xl: margin,
        xr: view.bounds.width - margin,
        yt: margin,
        yb: view.bounds.height - margin
    };
    for (var i = 0, l = sites.length; i < l; i++) {
        sites[i] = sites[i] * view.size / oldSize;
    }
    oldSize = view.size;
    renderDiagram();
}
*/
/*function onKeyDown(event) {
    if (event.key == 'space') {
        selected = !selected;
        renderDiagram();
    }
}*/