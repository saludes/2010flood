%In this approach there may be some space in the container.
clc; clf; clear all
qMax=0.8;
%volume of the Reservoir
W=0.75;


% time domain
t=fluxFunction('time');%0,10,N);
% flux function
q=fluxFunction('flux');
%number of points considered
N=length(q);
a=min(t);
b=max(t);
plot(t,q)

hold on
plot(linspace(a,b,N),linspace(a,b,N)*0+qMax,'--g')
xlabel('time')
ylabel('flux')
title('q(t)')

[peak,minPeak]=peakdet(q,0.1);
peakIndex=zeros(sum(peak(:,2)>qMax),1);
for i=1:length(peak(:,1))
    if(peak(i,2)>qMax)
        peakIndex(i)=peak(i,1);
    end
end
%peakIndex gives the index of the real potential threat peaks. 
%If they are a potential thread we must open the gates to try to reduce
%them. The most natural strategy is to try to delay the flood the most the
%most we can. 
%This may be different if, for some specific reason, we prefer having a
%flood at some particular time than another. Let's say for instance that we
%dont want to screw the agriculture at some point in time when its really
%needed. In this work, we will assume we want to prevent the flood the most
%we can. Therefore, we will deal first with the first possible threats.  
t0=a;
tf=b;
hold on
if(sum(peak(:,2)>qMax)==1)
    %there is just one problematic peak, but more than 1 peaks
    aux=1;
else
    %more than one problematic peak
    aux=0;
end
if(length(peak(:,1))==1)
   %if there is just one general peak
    aux=0;
end
for n=1:length(peak(:,1))-aux
    
    %computation of tf for the current peak
    if(length(peak(:,1))>1)
        if(n==length(peak(:,1)))
            tf=b;
        else
            tf=t(minPeak(n,1));
        end
        if(n==1)
            t0=a;
        else
            t0=t(minPeak(n-1,1));
        end
    else
        tf=b;
        t0=a;
    end
    
    clear tn
    clear qn
    tn=t(interp1(t,1:length(t),t0):interp1(t,1:length(t),tf));
    qn=q(interp1(t,1:length(t),t0):interp1(t,1:length(t),tf));

    %computing the volume. Vol=int(fluxFunction,0,t)
    for i=1:length(tn)
        vol(i)=quad(@fluxFunction,0,t(i));
    end
%     hold on
%     plot(tn,qn)
%     hold off
    
    
    [maxFlux, indexMaxFlux]=max(qn);
    qn_part1=qn(1:indexMaxFlux);
    qn_part2=qn(indexMaxFlux+1:length(qn));
    t1=interp1(qn_part1,tn(1:indexMaxFlux),qMax,'linear');
    t2=interp1(qn_part2,tn(indexMaxFlux+1:length(qn)),qMax,'linear');
    
    tn_part1=tn(1:indexMaxFlux);
    tn_part2=tn(indexMaxFlux+1:length(qn));
     
    tMax1=interp1(qn_part1,tn_part1,qMax);
    tMax2=interp1(qn_part2,tn_part2,qMax);
    
   
    if(W>quad(@fluxFunction1,tMax1,tMax2,[],[],tn,qn))
         V(n)=quad(@fluxFunction1,tMax1,tMax2,[],[],tn,qn);
        W=W-V(n);
    else
        %XXX
        auxVolume=0; tau=0.01; k=0;
        while(auxVolume<W)
            auxVolume=quad(@fluxFunction,tMax1,tMax1+tau*k);
            k=k+1;
        end
        tMax2=tMax1+tau*(k-1);
        V(n)=auxVolume;
        tThreshold_1(n)=tMax1;
        tThreshold_2(n)=tMax2;
        tDomain0(n)=t0;
        tDomainf(n)=tf;
        
        plot(linspace(tThreshold_1(n),tThreshold_2(n),N),...
            linspace(tThreshold_1(n),tThreshold_2(n),N)*0+qMax,'r')
        plot(linspace(qMax,fluxFunction(tMax2),N)*0+tMax2,...
            linspace(qMax,fluxFunction(tMax2),N),'r')
        break
    end
    tThreshold_1(n)=tMax1;
    tThreshold_2(n)=tMax2;
    tDomain0(n)=t0;
    tDomainf(n)=tf;
    
    plot(linspace(tThreshold_1(n),tThreshold_2(n),N),...
     linspace(tThreshold_1(n),tThreshold_2(n),N)*0+qMax,'r')
            
end
 W
%  plot(linspace(a,b,N),linspace(a,b,N)*0+qMax,'--g')
    [tThreshold_1' tThreshold_2']
    
    hold off
   

