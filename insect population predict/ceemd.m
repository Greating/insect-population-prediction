function [imft,residt,spec,w,a,dd,meancount,imfn,residn] = ceemd(x,thrsh,sthresh,N,alpha)
% Empiricial Mode Decomposition (Hilbert-Huang Transform)
% [imf,resid,spec,w,a,phs,meancount] = emd(x,thrsh,sthresh,N,alpha)
%   Inputs:
%         thrsh=thershold variance [0.2 to 0.3 usually]
 %        sthrh=threshold for first iteration [between 4/8]
%         N=number of trials for the ensemble emd
%         alpha=multiplier for white noise (defaults to .1*std(x) as  suggested by Huang)
%   Outputs:
%         imf= intrinsic mode functions (imf(:,end))
%         resid=residue; spec is the spectrum (A*e^jwt), w is the
%         frequency, a is the ampitlude, phs is the instphase
x   = transpose(x(:));
imf = [];
k=0;
xt=x;
if nargin<5,
    alpha=.1*std(xt);
end
cx=0;
s=0;
i=1;
lim=1;
imfprev=[];
while i<N+1,
    if i~=1,
        Noise=alpha.*randn(size(xt));
    else
        Noise=0;
    end
    for t=1:lim,
        count=0;
        x=xt+(-1)^t*Noise;
        while ~ismonotonic(x)
            count=count+1;
            if i==1,
                k=k+1;
                imf{count}=zeros(size(x));
                meancount(k)=0;
            end
           x1 = x;
           VA = Inf;
           cn=0;
           while (VA > thrsh) | ~isimf(x1)
               cn=cn+1;
              s1 = getspline(x1);
              s2 = -getspline(-x1);
              x2 = x1-(s1+s2)/2;
              VA = var((s1+s2)./(2*x1));
              x1 = x2;
              if i==1, cx=cx+1; elseif cn>cx*2, break; end
              if i==1 && cx>numel(xt)/2,
                  s=s+1;
                  if s>sthresh,
                      x1=xt+alpha.*randn(size(xt));
                      s=0;
                      cx=0;
                      disp('Restarting Sifting');
                  end
              end
           end
%            if cn>cx*2 && i~=1,
%                disp('Too long for ensemble member, breaking count')
%                flag=1;
%                break;
%            else
%                flag=0;
%            end
           
           if count<=k, 
               if i==1, 
                   imf{count} = x1+imf{count}; 
               else
                   imf{t,count}=x1+imf{t,count}; 
               end;
           else
               break;
           end
           x=x-x1;
        end
        
        if i==1,
            resid=repmat(x,2,1);
            imf=repmat(imf,2,1); 
%         elseif flag==0,
        else
            resid(t,:) = x+resid(t,:);
            if t==lim,
                meancount=meancount+1;
            end
%             residprev=x;
%         else
%             if t==lim,
%                 resid(1,:)=resid(1,:)-residprev;
%                 for l=1:numel(imf(1,:)),
%                     imf{1,l}=imf{1,l}-imfprev{l};
%                 end
%             end
%             i=i-1;
        end


    end


    disp(['Ensmble: ', num2str(i), ' Modes(' num2str(cx),'):', num2str(k)]);
     
    
    i=i+1;
     
    lim=2;


end
meancount=meancount+1;
imft=cell2mat(imf(1,:)')'+cell2mat(imf(2,:)')';
imfn=-cell2mat(imf(1,:)')'+cell2mat(imf(2,:)')';
resid=resid';
if N~=1,
    imft=imft./repmat(2*meancount,numel(imft(:,1)),1);
    imfn=imfn./repmat(2*meancount,numel(imft(:,1)),1);
    resid=resid/(2*N);
end
    residt=sum(resid,2);
    residn=-diff(resid,2);
    [spec,w,a,dd]=hilbspec(imft);
% FUNCTIONS

function u = ismonotonic(x)

u1 = length(findpeaks(x))*length(findpeaks(-x));
if u1 > 0, u = 0;
else,      u = 1; end

function u = isimf(x)

N  = length(x);
u1 = sum(x(1:N-1).*x(2:N) < 0);
u2 = length(findpeaks(x))+length(findpeaks(-x));
if abs(u1-u2) > 1, u = 0;
else,              u = 1; end

function s = getspline(x)

N = length(x);
p = findpeaks(x);
p=p(p~=1);
p=p(p~=numel(x));
zn=mean(x(p));
if abs(x(1))<abs(zn),
    x(1)=zn;
end
if abs(x(end))<abs(zn),
    x(end)=zn;
end

s = spline([0 p N+1],[x(1) x(p) x(end)],1:N);


function n = findpeaks(x)
% Find peaks.
% n = findpeaks(x)
n    = find(diff(diff(x) > 0) < 0);
u    = find(x(n+1) > x(n));
n(u) = n(u)+1;


function [spec,w,a,d]=hilbspec(imf),
    N=numel(imf(1,:));
    t=numel(imf(:,1));
    spec=zeros(t,N);
    w=zeros(t-1,N);
    a=spec;
    d=spec;
    for i=1:N,
        hv=hilbert(imf(:,i));
        do=phase(hv);
        w(:,i)=diff(do);
        a(:,i)=abs(hv);
        spec(:,i)=abs(hv).*exp(j*do);
        d(:,i)=do;
    end



