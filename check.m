%
% Plot values. a1(has dir+) a2(has dir-)
% Each row has command, stepgen, encoder.

clear all

if (1)
  %
  % Mill
  %
  if (0)
    %
    % Mill X
    %
  else
    %
    % Mill Y 
    %
    DEADBAND=0.0075;
    MIN_FERROR=0.02;
    MillDoubleYAxisMap
    t4=['Double nut'];

    a1(:,2:3)=a1(:,2:3)+HOME_OFFSET;
    a2(:,2:3)=a2(:,2:3)+HOME_OFFSET;
  end
else
  %
  % Lathe
  %
  if (0)
    LatheXAxisMap
    %
    % LatheX use G7/G8 in collection script to avoid this factor of 1/2.
    %
    a1(:,2:3)=a1(:,2:3) + HOME_OFFSET;
    a2(:,2:3)=a2(:,2:3) + HOME_OFFSET;
  elif (0)
    %
    % Single nut setup.
    %
    LatheZAxisMap
    t4=['Single nut'];
    home_offset = mean([a1(:,1) - a1(:,3); a2(:,1) - a2(:,3)])

    a1(:,2:3)=a1(:,2:3) + home_offset;
    a2(:,2:3)=a2(:,2:3) + home_offset;
  else
    %
    % double nut
    %
    LatheDoubleZAxisMap
    t4=['Double nut'];
    %
    % LatheZ doesn't home.
    %
    home_offset = mean([a1(:,1) - a1(:,3); a2(:,1) - a2(:,3)])

    a1(:,2:3)=a1(:,2:3) + home_offset;
    a2(:,2:3)=a2(:,2:3) + home_offset;
  end
end

if (0)
    figure(1)
    hold off
    plot(a1(:,1), a1(:,2),'r')
    hold on
    grid on
    plot(a2(:,1), a2(:,2),'r')
    xlabel('command[mm]')
    ylabel('position[mm]')
    title('axis position')
    plot(a1(:,1), a1(:,3),'g')
    plot(a2(:,1), a2(:,3),'g')
    legend(['stepgen'; 'encoder']);
    a=[min(a1(:,1)), max(a1(:,1)), min(min(a1(:,2)), min(a2(:,2))), max(max(a1(:,2)), max(a2(:,2)))];
    axis( a);
end

if (0)
    %
    % Figure 2 shows diff between command and stepgen.position-fb. These values should agree within +-DEADBAND when using stepgen.position_fb as _pos_fb.
    %
    figure(2)
    hold off
    d1 = a1(:,1)-a1(:,2);

    plot(a1(:,1), d1,'r')
    hold on
    grid on
    d2=a2(:,1) - a2(:,2);
    plot(a2(:,1), d2,'g')

    plot([a1(1,1),a1(end,1)]', [-DEADBAND,-DEADBAND]','--k')
    plot([a1(1,1),a1(end,1)]', [-MIN_FERROR,-MIN_FERROR]','--r')
    plot([a1(1,1),a1(end,1)]', [+DEADBAND,+DEADBAND]','--k');
    plot([a1(1,1),a1(end,1)]', [+MIN_FERROR,+MIN_FERROR]','--r');

    xlabel('command[mm]')
    ylabel('delta[mm]')
    title('(command - stepgen) vs position')
    legend(['dir-'; 'dir+'; 'DEADBAND';'MIN_FERROR']);

c=min([min(d1); min(d2); -MIN_FERROR*1.05])
d=max([max(d1); max(d2); +MIN_FERROR*1.05])
    a=[min(a1(:,1)), max(a1(:,1)), min([min(d1); min(d2); -MIN_FERROR*1.05]),max([max(d1); max(d2); +MIN_FERROR*1.05])]
    axis(a);
end

if (1)
  %
  % Figure 3 Show diff between command and encoder.position.
  # a1 and a2 contain triplets of (<commanded>, <stepgen_pos>, #<encoder_pos>)
  #
  % When using when using stepgen.position_fb as _pos_fb this shows backlash and any alignment problems.
  %
  figure(3)
  hold off
  e1 = a1(:,1) - a1(:,3)
  plot(a1(:,1), e1,'r')
  
  hold on
  grid on
  e2 = a2(:,1) - a2(:,3)
  plot(a2(:,1), e2,'g')

  plot([a1(1,1),a1(end,1)]', [-DEADBAND,-DEADBAND]','--k')
  plot([a1(1,1),a1(end,1)]', [-MIN_FERROR,-MIN_FERROR]','--r')
  plot([a1(1,1),a1(end,1)]', [+DEADBAND,+DEADBAND]','--k');
  plot([a1(1,1),a1(end,1)]', [+MIN_FERROR,+MIN_FERROR]','--r');

  xlabel('command[mm]')
  ylabel('delta[mm]')
  title('(command - encoder) vs position')
  legend(['dir-'; 'dir+'; 'DEADBAND';'MIN\_FERROR']);
  ymin=   min([min(e1), min(e2), -MIN_FERROR*1.05])
  ymax=   max([max(e1), max(e2), +MIN_FERROR*1.05])

  a =[
      min(a1(:,1)),
      max(a1(:,1)),
      min([min(e1), min(e2), -MIN_FERROR*1.05]),
      max([max(e1), max(e2), +MIN_FERROR*1.05])
      ]
  axis( a);
end

if (0)
  %
  % Figure 4 Show a linear fit to each direction.
  % The slope should correspond to the misalignment angle.
  %

  %
  % Discard the first and last values to calculate backlash.
  %
  x1 =a1(10:end-1,1);
  x2 =flip(a2(10:end-1,1));
  y1=e1(10:end-1);
  y2=flip(e2(10:end-1));

  figure(4)
  hold off
  plot(x1,y1,'r')
  hold on
  plot(x2,y2,'g')

  plot(x1,y1-y2,'b')
  title(t4);

  %scatter(x1,y1,25,'r','*')
  P = polyfit(x1,y1,1);
  yfit = polyval(P,x1);
  hold on;
  plot(x1,yfit,'r-.');
  eqn = sprintf(' Linear fit: y = %f x + %f', P(1), P(2));
  disp(eqn)

  %scatter(x2,y2,25,'g','*')
  P = polyfit(x2,y2,1);
  yfit2 = polyval(P,x2);
  hold on;
  plot(x2,yfit2,'g-.');
  eqn = sprintf(' Linear fit: y = %f x + %f', P(1), P(2));
  disp(eqn)

  %a =[min(x1), max(x1), min([min(y1), min(y2), -MIN_FERROR*1.05]), max([max(y1), max(y2), +MIN_FERROR*1.05])];
  %axis( a);
  grid on
end

if (0)
    %
    % Even a linear fit (adjusting alignment, there is still quite a bit of error.)
    %
    figure(5)
    hold off
    plot(x1,y1-yfit)
    hold on
    plot([a1(1,1),a1(end,1)]', [-DEADBAND,-DEADBAND]','--k')
    plot([a1(1,1),a1(end,1)]', [-MIN_FERROR,-MIN_FERROR]','--r')
    plot([a1(1,1),a1(end,1)]', [+DEADBAND,+DEADBAND]','--k');
    plot([a1(1,1),a1(end,1)]', [+MIN_FERROR,+MIN_FERROR]','--r');
    a =[min(x1), max(x1), min([min(y1), min(y2), -MIN_FERROR*1.05]), max([max(y1), max(y2), +MIN_FERROR*1.05])];
    axis( a);
    grid on
end
