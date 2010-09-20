function [q]=fluxFunction1(t,tVector,qVector)
    q=interp1(tVector,qVector,t);
    