--[[200    
600
1200
2000
3000
4200
5600
7200
9000
11000      10级以前可以送水  400~1000随机经验
13200
15600
18200
21000
24000
27200
30600
34200
38000
42000    
46200
50600
55200
60000       在此之前都可以杀熊怪   40000~80000随机经验  
65000
70200
75600
81200
87000
93000
99200
105600
112200
119000
126000
133200
140600
148200
156000
164000       小型副本    150000~250000随机经验 + 5000金  副本内掉落装备
172200
180600
189200
198000
207000
216200
225600
235200
245000
255000
265200
275600
286200
297000
308000
319200
330600
342200
354000
366000           	      
378200
390600
403200
416000
429000
442200
455600
469200
483000
497000
511200
525600
540200
555000
570000
585200
600600
616200
632000
648000 				中型副本    50W到70W的随机经验  +10000金  副本内掉落装备
664200
680600
697200
714000
731000
748200
765600
783200
801000
819000
837200
855600
874200
893000
912000
931200
950600
970200
990000
1010000
1030200
1050600
1071200
1092000
1113000
1134200
1155600
1177200
1199000
1221000
1243200
1265600
1288200
1311000
1334000
1357200
1380600
1404200
1428000
1452000
1476200
1500600
1525200
1550000
1575000
1600200
1625600
1651200
1677000
1703000
1729200
1755600
1782200
1809000
1836000
1863200
1890600
1918200
1946000				大型副本 	200W~300W随机经验   2W金   副本内掉落装备

]]

--自定义等级

-- 自定义最大等级
CUSTOM_MAX_LEVEL = 90

-- 经验图表
CUSTOM_XP_TABLE = {}
local xp = 0
for i=1,CUSTOM_MAX_LEVEL - 1 do
  CUSTOM_XP_TABLE[i] = xp
  xp = xp + i  * 200 
end