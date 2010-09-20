function [q]=fluxFunction(t)
%definition of a function that describes the hydrograph
tVector=linspace(0,10,201);

%% function 1
% qVector=exp(-(tVector-5).^2/(2));

%% function 2
% qVector=exp(-(tVector-3).^2/(1))+exp(-(tVector-7).^2/(1));

%% function 3
% qVector=exp(-(tVector-3).^2/(0.1))+0.5*exp(-(tVector-7).^2/(4));
 
 %% function 4
qVector=0.15*exp(-(tVector-3).^2/(0.1))+exp(-(tVector-5).^2/(1))+0.85*exp(-(tVector-7).^2/(0.1));

if (strcmp(t,'time'))
    q=tVector;
else
    if (strcmp(t,'flux'))
        q=qVector;
    else
        q=interp1(tVector,qVector,t);
    end
end

% %% Gaussian profile
% qp=1;
% tp=5;
% tb=1;
% tVector=linspace(0,10,100);
% qVector=qp*exp(-(tVector-tp).^2/(2*tb^2));


%q=qp*exp(-(t-tp).^2/(2*tb^2));



%%
% load gemtdata1t
%qVector=XX;
%tVector=XX;
% q=interp1(tVector,qVector,t);
