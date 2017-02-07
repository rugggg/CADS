for i=1:10
    for j=1:10
        [t,y]=ode45(@odeHelper,[0:.1:15],[.1*i,.1*j]); %first arg is range to plot, second is intial condition
        plot(y(:,1),y(:,2),'b');
        hold on
    end
end
