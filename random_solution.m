x = [28	2	0	1	44	48	2
8	1	1	1	15	78	1
8	1	2	1	16	59	2
12	2	1	1	23	36	2
12	2	2	1	24	33	2
9	2	1	1	17	64	1
9	2	2	1	18	22	2
6	1	1	1	11	80	1
6	1	2	1	12	79	2
31	2	0	1	47	63	2
7	1	1	1	13	86	2
7	1	2	1	14	25	2
19	1	0	1	35	17	1
30	2	0	1	46	35	2
5	1	1	1	9	49	2
5	1	2	1	10	4	2
3	1	1	1	5	43	2
3	1	2	1	6	88	2
26	2	0	1	42	8	1
22	1	0	1	38	90	2
27	2	0	1	43	45	1
2	1	1	1	3	1	1
2	1	2	1	4	32	2
29	2	0	1	45	24	2
21	1	0	1	37	67	2
32	2	0	1	48	7	2
18	1	0	1	34	31	1
15	2	1	1	29	27	1
15	2	2	1	30	62	2
1	1	1	1	1	12	1
1	1	2	1	2	76	2
4	1	1	1	7	34	1
4	1	2	1	8	95	2
10	2	1	1	19	65	2
10	2	2	1	20	74	2
11	2	1	1	21	61	1
11	2	2	1	22	38	2
20	1	0	1	36	5	2
16	2	1	1	31	57	2
16	2	2	1	32	21	2
23	1	0	1	39	52	2
14	2	1	1	27	39	1
14	2	2	1	28	77	2
13	2	1	1	25	54	1
13	2	2	1	26	73	2
25	2	0	1	41	56	1
17	1	0	1	33	10	1
24	1	0	1	40	16	2
60	2	0	0	92	47	2
58	2	0	0	90	89	1
42	2	1	0	67	23	2
42	2	2	0	68	42	2
54	1	0	0	86	44	2
56	1	0	0	88	94	2
51	1	0	0	83	41	1
40	1	1	0	63	69	1
40	1	2	0	64	29	2
43	2	1	0	69	15	1
43	2	2	0	70	2	2
55	1	0	0	87	9	2
57	2	0	0	89	28	1
35	1	1	0	53	11	2
35	1	2	0	54	6	2
33	1	1	0	49	19	1
33	1	2	0	50	37	2
48	2	1	0	79	83	2
48	2	2	0	80	55	2
49	1	0	0	81	20	1
45	2	1	0	73	3	1
45	2	2	0	74	46	2
41	2	1	0	65	68	1
41	2	2	0	66	72	2
52	1	0	0	84	50	2
62	2	0	0	94	81	2
46	2	1	0	75	58	1
46	2	2	0	76	96	2
38	1	1	0	59	14	1
38	1	2	0	60	71	2
64	2	0	0	96	53	2
53	1	0	0	85	84	2
34	1	1	0	51	40	1
34	1	2	0	52	70	2
39	1	1	0	61	60	2
39	1	2	0	62	75	2
61	2	0	0	93	30	2
36	1	1	0	55	92	1
36	1	2	0	56	18	2
63	2	0	0	95	66	2
50	1	0	0	82	51	1
47	2	1	0	77	26	1
47	2	2	0	78	91	2
59	2	0	0	91	93	1
44	2	1	0	71	82	2
44	2	2	0	72	13	2
37	1	1	0	57	85	2
37	1	2	0	58	87	2
];

ncols = size(x,2);

% make a new matrix that builds pairs into rows
y = [];
while ~isempty(x)
    % check the next row of x
    if x(1,3) == 1
        % the next row is the first item of a pair, put both pairs in the
        % next row of y
        y(end+1, :) = [x(1,:) x(2,:)];
        x(1:2,:) = [];
    else
        % otherwise, last 7 columns are just 0's
        y(end+1, :) = [x(1,:) zeros(1, ncols)];
        x(1,:) = [];
    end
end

% shuffle y
y = y(Shuffle(1:size(y,1)), :);

% reconstruct x
x = [];
xidx = 1;
for idx = 1:size(y,1)
    if y(idx, 3) == 1
        % unpack two rows
        x(xidx,:) = y(idx,1:ncols);
        x(xidx+1, :) = y(idx, (ncols+1):end);
        xidx = xidx+2;
    else
        x(xidx,:) = y(idx,1:ncols);
        xidx=xidx+1;
    end
end
disp(x)
        
