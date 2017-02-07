for i=1:50
    for j=1:50
        [t,y]=ode45(@predPrey,[0:.1:1],[i,j]); %first arg is range to plot, second is intial condition
        plot(y(:,1),y(:,2),'b');
        hold on
    end
end
