t = sym('t');

f = 2*heaviside(t) - 2*heaviside(t-1) + heaviside (t-1) - heaviside(t-2);

f1 = subs(f, t, -t);

f2 = subs(f, t, t-2);

f3 = subs(f, t, 0.5*t);
f31 = subs(f, t, 2*t);

f4 = subs(f, t, 0.5*t +1);

figure;

subplot(2,2,1);
fplot(f1);
title("f(-t)");

subplot(2,2,2);
fplot(f2);
title("f(t-2)");

subplot(2,2,3);
fplot(f3);
hold on;
fplot(f31);
title("f(0.5t) and f(2t)");
hold off;

subplot(2,2,4);
fplot(f4);
title("f(0.5t +1)");

saveas(gcf, './p2_signals.png');
