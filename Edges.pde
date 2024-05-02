import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.List;


class Edges {
    PShape s;
    List<List<SimpleVector>> foundCycles;
    ArrayList<PVector[]> myMemory = new ArrayList<PVector[]>();
    PVector vS = new PVector(-1, -1);
    boolean isSecond = false;
    HashSet<Set<SimpleVector>> collectedEdges = new HashSet<Set<SimpleVector>>();
    ArrayList<Float> randomVals = new ArrayList<Float>();

    Edges(){
        // Since we wouldn't wanna update a the random value every frame, we determine random values once on construction
        for (int i = 0; i< 900; i++){
            randomVals.add(random(-7, 7));
        }
    }

    int getcoord(float val){
        return int((val*mult)+constOffset);
    }

    void setPoint(PVector p1) {
        // If only one button has been pressed, fill up vS with the pressed button
        if (!isSecond){
            vS.set(p1.x, p1.y);
            isSecond = true;
        }
        // and they're not the same button
        else if (vS.x == p1.x && vS.y == p1.y) {
            ;
        }
        // we have an edge that we can work with
        else if (isSecond){
            
            /** 
             *
             * Since we only can work with hashable values in graphs and 
             * PVector is sadly not on of them, I had to make my own hashable
             * Value called SimpleVector which does basically the same as
             * PVector
             *
             */
            LinesGraph.addVertex(new SimpleVector(p1));
            LinesGraph.addVertex(new SimpleVector(vS));

            Set<SimpleVector> compSet = new HashSet<SimpleVector>();
            compSet.add(new SimpleVector(p1));
            compSet.add(new SimpleVector(vS));          

            if (LinesGraph.addEdge(new SimpleVector(p1), new SimpleVector(vS))){
                // Add the lines to myMemory so they can be printed out as lines
                myMemory.add(new PVector[]{new PVector(vS.x, vS.y), new PVector(p1.x, p1.y)});
                // Check previous edges with the current one for intersection
                for (Set<SimpleVector> edgeSet: collectedEdges){
                    SimpleVector[] tEdge = edgeSet.toArray(new SimpleVector[2]);

                    // Conversion of the EdgeSet Values in PVector
                    PVector q1 = new PVector(tEdge[0].x, tEdge[0].y);
                    PVector q2 = new PVector(tEdge[1].x, tEdge[1].y);

                    SimpleVector s1 = new SimpleVector(p1);
                    SimpleVector s2 = new SimpleVector(vS);
                    

                    // Check if the lines have an intersection                    
                    PVector target = get_line_intersection(p1, vS, new PVector(tEdge[0].x, tEdge[0].y), new PVector(tEdge[1].x, tEdge[1].y));
                    if (target.x != -1.0){
                        LinesGraph.removeEdge(s1, s2);
                        LinesGraph.removeEdge(tEdge[0], tEdge[1]);
                        LinesGraph.addVertex(new SimpleVector(target));
                        // Add cutted p1 Target and vS Target to LinesGraph
                        LinesGraph.addEdge(new SimpleVector(target), s1);
                        LinesGraph.addEdge(new SimpleVector(target), s2);
                        LinesGraph.addEdge(new SimpleVector(target), tEdge[0]);
                        LinesGraph.addEdge(new SimpleVector(target), tEdge[1]);
                    }
                }
                collectedEdges.add(compSet);
            }

            foundCycles = LinesGraph.findAllSimpleCycles();

            isSecond = false;
        }
    }

    void drawLines(color strokeColorValue, int strokeWeightValue) {
        for (int i = 0; i < myMemory.size(); i++){
            strokeWeight(strokeWeightValue);
            stroke(strokeColorValue);
            line(getcoord(myMemory.get(i)[0].x), getcoord(myMemory.get(i)[0].y), getcoord(myMemory.get(i)[1].x), getcoord(myMemory.get(i)[1].y));

            pushMatrix();
            translate(width, 0);
            scale(-1, 1);
            line(getcoord(myMemory.get(i)[0].x), getcoord(myMemory.get(i)[0].y), getcoord(myMemory.get(i)[1].x), getcoord(myMemory.get(i)[1].y));
            popMatrix();

            pushMatrix();
            translate(0, height);
            scale(1, -1);
            line(getcoord(myMemory.get(i)[0].x), getcoord(myMemory.get(i)[0].y), getcoord(myMemory.get(i)[1].x), getcoord(myMemory.get(i)[1].y));
            popMatrix();

            pushMatrix();
            translate(width, height);
            scale(-1, -1);
            line(getcoord(myMemory.get(i)[0].x), getcoord(myMemory.get(i)[0].y), getcoord(myMemory.get(i)[1].x), getcoord(myMemory.get(i)[1].y));
            popMatrix();
        }
        
    }

    void drawShape(color shapeColor){
        s = createShape();
        
        if (foundCycles != null){
            for (int i = 0; i < foundCycles.size(); i++){
                if (i == shapeVariationCtl){
                    s.beginShape();
                    s.fill(shapeColor);
                    s.noStroke();
                    s.vertex(
                    getcoord(foundCycles.get(i).get(0).x),
                    getcoord(foundCycles.get(i).get(0).y)
                    );
                    // Add the random verticies
                    for (int j = 1; j < foundCycles.get(i).size(); j++){
                        s.quadraticVertex(
                            getcoord(foundCycles.get(i).get(j).x + randomVals.get((j-1)*2)*bezierAmt),
                            getcoord(foundCycles.get(i).get(j).y + randomVals.get(((j-1)*2)+1)*bezierAmt),
                            getcoord(foundCycles.get(i).get(j).x),
                            getcoord(foundCycles.get(i).get(j).y)
                        );
                    }
                    s.endShape();
                    shape(s);
                }
            }
        }

        shape(s);
        pushMatrix();
        translate(width, 0);
        scale(-1, 1);
        shape(s);
        popMatrix();

        pushMatrix();
        translate(0, height);
        scale(1, -1);
        shape(s);
        popMatrix();

        pushMatrix();
        translate(width, height);
        scale(-1, -1);
        shape(s);
        popMatrix();
    }

    PVector get_line_intersection(PVector p0, PVector p1, PVector p2, PVector p3){
        // Algorithm implemented from here: https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
        PVector s1 = new PVector(0, 0);
        PVector s2 = new PVector(0, 0);
        PVector res = new PVector(-1, -1);
        PVector res2 = new PVector(-1, -1);

        s1.set(p1);
        s2.set(p3);
        s1.sub(p0);
        s2.sub(p2);

        // Calculate the determinant of the two lines ie if parallel
        float det = (-s2.x * s1.y + s1.x * s2.y);

        // check for overlapping
        float s, t;
        s = (-s1.y * (p0.x - p2.x) + s1.x * (p0.y - p2.y)) / det;
        t = ( s2.x * (p0.y - p2.y) - s2.y * (p0.x - p2.x)) / det;

        if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
        {
            // Collision detected
            float i_x = p0.x + (t * s1.x);
            float i_y = p0.y + (t * s1.y);
            res.set(i_x, i_y);
        }


        return res; // No collision
    }

    void clear(){
        myMemory.clear();
        collectedEdges.clear();
        foundCycles.clear();
    }
    
}