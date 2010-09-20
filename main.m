%in this approach the container is always full of water
clc; clf; clear all
%volume of the Reservoir
W=1;

% time domain
t=fluxFunction('time');%0,10,N);
% flux function
q=fluxFunction('flux');
%number of points considered
N=length(q);

a=min(t);
b=max(t);

%computing the volume. Vol=int(fluxFunction,0,t)
for i=1:length(t)
    vol(i)=quad(@fluxFunction,0,t(i));
end
%Determine qf
range=0.025*W;
j=1;
for i=1:length(q)
    q_VpW=interp1(vol,q,q(i)+W,'linear');
    if(q(i)<q_VpW+range && q(i)>q_VpW-range)
        index(j)=i;
        j=j+1;
    end
end
index
%v1 and v2 corresponds to t1 and t2. I.e. the volume for which q=qf
v1=vol(index(1));
v2=vol(index(2));
%q1=q2=qf
q1=q(index(1));
q2=q(index(2));

%To find the time t1 and t2 corresponding to v1 and v2
[maxFlux, indexMaxFlux]=max(q);
q_part1=q(1:indexMaxFlux);
q_part2=q(indexMaxFlux+1:length(q));
t1=interp1(q_part1,t(1:indexMaxFlux),q1,'linear');
t2=interp1(q_part2,t(indexMaxFlux+1:length(q)),q2,'linear');

%figure 1, figure for the flux Vs volume
figure(1)
plot(vol,q,linspace(v1,v2,N),linspace(v1,v2,N)*0+q1,'r')
xlabel('volume v'); ylabel('flux q'); title('q(v)')

%figure 2, figure for the flux Vs time
figure(2)
plot(t,q)
xlabel('time t'); ylabel('flux q'); title('q(t)')

% quad(@fluxFunction,t1,t2)
%% 
hold on
%defining qMax
qMax=0.8;
plot(linspace(a,b,N),linspace(a,b,N)*0+qMax,'--g')
%auxVolume:Volume that has been filled at certain time
%n and tau are variables to increase the time after tMax1 is reached 
auxVolume=0; n=0; tau=0.1;
if(q1>qMax)
    tMax1=interp1(q_part1,t(1:indexMaxFlux),qMax);
    while(auxVolume<W)
        auxVolume=quad(@fluxFunction,tMax1,tMax1+tau*n);
        n=n+1;
    end
    tMax2=tMax1+tau*(n-1);
    plot(linspace(tMax1,tMax2,N),linspace(tMax1,tMax2,N)*0+qMax,'r')
    plot(linspace(qMax,fluxFunction(tMax2),N)*0+tMax2,...
        linspace(qMax,fluxFunction(tMax2),N),'r')
else
    plot(t,q,linspace(t1,t2,N),linspace(t1,t2,N)*0+q1,'r')
end
