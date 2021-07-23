 function [acc]=vel2acc(vel, dt)
   nt=length(vel);
   acc=zeros(nt, 1);
   for k=2:nt
      acc(k)=(vel(k) - vel(k-1))/dt;
   end
   return