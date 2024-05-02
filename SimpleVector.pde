public class SimpleVector{
    public Float x, y;
    public SimpleVector(PVector p1){
        x = p1.x;
        y = p1.y;
    }
    @Override
    public int hashCode() {
        return x.hashCode() ^ y.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof SimpleVector) && ((SimpleVector) obj).x.equals(x)
                                       && ((SimpleVector) obj).y.equals(y);
    }

    @Override
    public String toString() {
        return "x:" + x + "  y:"+ y;
    }
}