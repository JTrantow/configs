%
% Plot values. a1(has dir+) a2(has dir-)
% Each row has command, stepgen, encoder.

clear all

if (0)
  %
  % Mill X
  %
  clear all
  if (0)
    MillMap
    t4=['Mill Single nut X'];
    FERROR        = 0.500000
    MIN_FERROR    = 0.100000
    DEADBAND      = 0.003000
    %
    %
    %
    a1(:,2:3)=a1(:,2:3)+180;
    a2(:,2:3)=a2(:,2:3)+180;
  elseif (1)
    MillDoubleXAxisMap
    t4=['Mill Double nut X'];
    offset=mean(a1(:,1) - a1(:,2))
    a1(:,2:3)=a1(:,2:3) + offset;
    a2(:,2:3)=a2(:,2:3) + offset;
  elseif (0)
  %
  % Mill Y
  %
    %
    % Original ballscrew.
    %
    MillY
    t4=['Mill Single nut X'];
    FERROR        = 0.500000
    MIN_FERROR    = 0.100000
    DEADBAND      = 0.003000
    a1(:,2:3)=a1(:,2:3)+180;
    a2(:,2:3)=a2(:,2:3)+180;
  elseif (0)
    MillDoubleYAxisMap
    t4=['Mill Double nut Y'];

    a1(:,2:3)=a1(:,2:3)+HOME_OFFSET;
    a2(:,2:3)=a2(:,2:3)+HOME_OFFSET;
  end
else
  %
  % Lathe
  %
  if (1)
    LatheXAxisMap
    %
    % LatheX use G7/G8 in collection script to avoid this factor of 1/2.
    %
    a1(:,2:3)=a1(:,2:3) + HOME_OFFSET;
    a2(:,2:3)=a2(:,2:3) + HOME_OFFSET;
    t4=['Lathe X nut'];
  elseif (0)
    %
    % Single Z nut setup.
    %
    LatheZAxisMap
    t4=['Single nut'];
    home_offset = mean([a1(:,1) - a1(:,3); a2(:,1) - a2(:,3)])

    a1(:,2:3)=a1(:,2:3) + home_offset;
    a2(:,2:3)=a2(:,2:3) + home_offset;
  else
    %
    % double Z nut
    %
    LatheDoubleZAxisMap
    t4=['Lathe Double nut'];
    %
    % LatheZ doesn't home.
    %
    home_offset = mean([a1(:,1) - a1(:,3); a2(:,1) - a2(:,3)])

    a1(:,2:3)=a1(:,2:3) + home_offset;
    a2(:,2:3)=a2(:,2:3) + home_offset;
  end
end

if (0)
    %
    % Figure 1 shows command vs stepgen,encoder. Should be a linear line with slope 1 if the scaling is correct.
    %
    figure(1)
    hold off
    plot(a1(:,1), a1(:,2),'r')
    hold on
    plot(a2(:,1), a2(:,2),'r')
    xlabel('command[mm]')
    ylabel('position[mm]')
    title('axis position')
    plot(a1(:,1), a1(:,3),'g')
    plot(a2(:,1), a2(:,3),'g')
    legend(['stepgen'; 'encoder']);
    a=[min(a1(:,1)), max(a1(:,1)), min(min(a1(:,2)), min(a2(:,2))), max(max(a1(:,2)), max(a2(:,2)))];
    axis( a);
    grid on
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
    grid on
end

if (1)
  %
  % Figure 3 Show diff between command and encoder.position.
  # a1 and a2 contain triplets of (<commanded>, <stepgen_pos>, #<encoder_pos>)
  #
  % When using when using stepgen.position_fb as _pos_fb this shows backlash and any encoder alignment problems.
  %
  figure(3)
  hold off
  e1 = a1(:,1) - a1(:,3)
  plot(a1(:,1), e1,'r')

  hold on
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
  grid on
end

if (1)
  %
  % Figure 4 Show a linear fit to the encoder in each direction.
  % The slope should correspond to the misalignment angle between the encoder and actual motion.
  % The difference is the backlash.

  %
  % Discard the first and last values where direction changes to calculate backlash.
  % Could change collection to start beyond the range to avoid the direction change within the data.
  %
  x1 = a1(2:end-1,1)
  x2 = flip(a2(2:end-1,1))
  y1 = e1(2:end-1)
  y2 = flip(e2(2:end-1))

  figure(4)
  hold off
  plot(x1,y1,'r')
  hold on
  plot(x2,y2,'g')

  plot(x1,abs(y1-y2),'b')
  title(t4);
  xlabel('command[mm]');
  ylabel('diff');

  %scatter(x1,y1,25,'r','*')
  P = polyfit(x1,y1,1);
  yfit = polyval(P,x1);
  plot(x1,yfit,'r-.');
  eqn = sprintf(' Linear fit: y = %f x + %f', P(1), P(2));
  disp(eqn)

  %scatter(x2,y2,25,'g','*')
  P = polyfit(x2,y2,1);
  yfit2 = polyval(P,x2);
  plot(x2,yfit2,'g-.');
  eqn = sprintf(' Linear fit: y = %f x + %f', P(1), P(2));
  disp(eqn)

  a =[min(a1(:,1)),
      max(a1(:,1)),
      min([min(y1), min(y2), min(abs(y1-y2)),-MIN_FERROR*1.05]),
      max([max(y1), max(y2), max(abs(y1-y2)), +MIN_FERROR*1.05])];
  axis( a)
  grid on
end


if (1)
    %
    % Correct the encoder values using the linear fit.
    %
    figure(5)
    hold off
    plot(x1,y1-yfit,  'r')
    hold on
    plot(x2,y2-yfit2, 'g')
    plot([a1(1,1),a1(end,1)]', [-DEADBAND,-DEADBAND]','--k')
    plot([a1(1,1),a1(end,1)]', [-MIN_FERROR,-MIN_FERROR]','--r')
    plot([a1(1,1),a1(end,1)]', [+DEADBAND,+DEADBAND]','--k');
    plot([a1(1,1),a1(end,1)]', [+MIN_FERROR,+MIN_FERROR]','--r');

    a =[min(a1(:,1)),
        max(a1(:,1)),
        min([min(y1-yfit), min(y2-yfit2), min(abs(y1-y2)), -MIN_FERROR*1.05]),
        max([max(y1-yfit), max(y2-yfit2), max(abs(y1-y2)), +MIN_FERROR*1.05])];
    axis( a)
    grid on
  end
