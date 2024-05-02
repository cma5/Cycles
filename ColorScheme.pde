import java.util.ArrayList;

class Colorscheme {
    public ArrayList<Integer> foreground;
    public ArrayList<Integer> background;

    Colorscheme() {
        foreground = new ArrayList<Integer>();
        background = new ArrayList<Integer>();

        foreground.add(color(#000000));
        foreground.add(color(#FFFFFF));

        foreground.add(color(#fed4f2));
        foreground.add(color(#d2dafe));
        foreground.add(color(#ff85df));

        foreground.add(color(#f2efea));
        foreground.add(color(#b8b2e2));
        foreground.add(color(#f0ede9));

        foreground.add(color(#addcfd));
        foreground.add(color(#f76823));
        foreground.add(color(#eecbea));

        foreground.add(color(#7ace91));
        foreground.add(color(#ffaa5c));
        foreground.add(color(#f7fbf9));


        background.add(color(#FFFFFF));
        background.add(color(#000000));

        background.add(color(#FF88DC));
        background.add(color(#91A6FF));
        background.add(color(#FAFF7F));

        background.add(color(#C2AFF0));
        background.add(color(#686868));
        background.add(color(#9191E9));
        
        background.add(color(#1392D9));
        background.add(color(#F3CCE7));
        background.add(color(#036147));

        background.add(color(#BCEBCB));
        background.add(color(#F7FFF6));
        background.add(color(#FCAB64));

    }
}
