-- create View / Drop View
-- เอาไว้สร้าง table เพื่อไม่ให้ส่ง table จริงมา ก็คือการเอากรอบมาครอบไว้อีกรอบ ทำให้ไม่ต้องไป where หลายๆอย่าง
CREATE VIEW SC_STUDENT(sid, name, gpa, major)
as 
    (select  sid, nmae, gpa, major
    from    student
    where   major = 'cs')
/*********************************************************/
select  *
from    SC_STUDENT

drop view SC_STUDENT
/*********************************************************/
-- 8.1 สร้าง view ต่างๆ ตามเงือนไขต่อไปนี้
-- 1. GOOD_STD(sid, gpa) โดยมีเฉพาะข้อมูลของนิสิตที่ gpa 3.00 ขึ้นไป
CREATE VIEW GOOD_STD(sid, gpa)
as  
    (SELECT  sid, gpa
    FROM    STUDENT
    WHERE   gpa >= 3.00)

DROP VIEW GOOD_STD

SELECT  *
FROM    GOOD_STD

-- 2. LEC_TCH(lid, amount) โดยมีข้อมูลรหัสอาจารย์ และจำนวนวิชาที่เคยสอนทั้งหมด
CREATE VIEW LEC_TCH(lid, amount)
as 
    (SELECT      lecid as lid,
                COUNT(*) as amount
    FROM        SECTION
    GROUP BY    lecid)

SELECT  *
FROM    LEC_TCH

-- 3. Lecturer_Load (lecid, term, amount) โดยเป็นข้อมูลรหัสอาจารย์ ภาคเรียน และจำนวนวิชาที่สอนในภาคเรียนนั้น ๆ ของอาจารย์ 
CREATE VIEW Lecturer_Load(lecid, term, amount)
as 
    (SELECT      lecid, 
                term, 
                COUNT(lecid) as amount
    FROM        SECTION
    GROUP BY    term, lecid)

SELECT  *
FROM    Lecturer_Load


-- 4. Student_Credit (stdid, sum_credit) เป็นข้อมูลรหัสนิสิต และจำนวนหน่วยกิตที่เรียนทั้งหมด เฉพาะที่เกรดไม่เป็น F
CREATE VIEW Student_Credit(stdid, sum_credit)
as 
    (SELECT  ENROLL.stdid as stdid,
            SUM(SUBJECT.credit) as sum_credit
    FROM    ENROLL, SECTION, SUBJECT
    WHERE   ENROLL.secid    = SECTION.secid
    AND     SECTION.subid   = SUBJECT.sid
    AND     ENROLL.grade    != 'F'
    GROUP BY ENROLL.stdid)

DROP VIEW Student_Credit

SELECT  *
FROM    Student_Credit

-- 5. Major_Detail(major, amount, max_gpa, min_gpa, avg_gpa ) โดยเป็นข้อมูล ชื่อภาควิชา, จำนวนนิสิต, gpa สูงสุด, gpa ต่ำสุด และ gpa เฉลี่ย ในภาควิชานั้น
CREATE VIEW Major_Detail(major, amount, max_gpa, min_gpa, avg_gpa)
as
    (SELECT     major,
                COUNT(sid)  as amount,
                MAX(gpa)    as max_gpa,
                MIN(gpa)    as min_gpa,
                AVG(gpa)    as avg_gpa
    FROM        STUDENT
    WHERE       major IS NOT NULL
    AND         name IS NOT NULL
    GROUP BY    major)

DROP VIEW Major_Detail

SELECT  *
FROM    Major_Detail

-- 8.2 ใช้ View ที่เคยสร้างไว้แล้ว หรือสร้าง View ใหม่ ตามที่คิดว่าเหมาะสม เพื่อทำงานต่อไปนี้
-- 1.แสดงรายชื่อของนิสิตทั้งหมดที่อยู่ใน major ที่มี gpa เฉลี่ยสูงที่สุด
SELECT  STUDENT.name,
        STUDENT.major
FROM    STUDENT, Major_Detail
WHERE   STUDENT.major = Major_Detail.major
AND     Major_Detail.avg_gpa = 
                            (SELECT MAX(avg_gpa)
                            FROM    Major_Detail)

-- 2.แสดง ชื่อนิสิต , ภาควิชา และ gpa ของนิสิต ที่ได้ gpa ต่ำสุดในแต่ละภาควิชา
SELECT  STUDENT.name,
        STUDENT.major,
        GPA
FROM    STUDENT, Major_Detail
WHERE   STUDENT.GPA = Major_Detail.min_gpa
AND     STUDENT.major = Major_Detail.major

-- 3.แสดง รหัสนิสิต , ชื่อนิสิต และจำนวนหน่วยกิตที่เรียนทั้งหมด ของนิสิตภาควิชา CS เท่านั้น
SELECT  sid,
        name,
        sum_credit
FROM    STUDENT, Student_Credit
WHERE   STUDENT.sid  = Student_Credit.stdid
ANd     STUDENT.major = 'CS'

-- 4.แสดงรหัส ชื่ออาจารย์และภาควิชา ของอาจารย์ที่สอนหลายวิชาที่สุด
SELECT  LECTURER.lid,
        name,
        major
FROM    LECTURER, LEC_TCH
WHERE   LECTURER.lid = LEC_TCH.lid
AND     LEC_TCH.amount = 
                    (SELECT max(amount)
                    FROM    LEC_TCH)

-- 5.ใช้ข้อมูลการสอนของอาจารย์ในเทอม 2-2020 เพื่อเพิ่มเงินเดือนให้อาจารย์ 
-- โดยให้เพิ่มวิชาละ 1,000 บาท (เช่นถ้าสอน 2 วิชา เพิ่มเงินเดือน 2,000 บาท)
UPDATE  LECTURER
set     salary = salary + (1000 * amount)
FROM    LECTURER, Lecturer_Load
WHERE   LECTURER.lid = Lecturer_Load.lecid 
AND     Lecturer_Load.term = '2-2020'

SELECT  *
FROM    LECTURER

-- 6.เพิ่มเงินให้อาจารย์ ตามจำนวนครั้งที่เคยสอนทั้งหมด ตามเงื่อนไขต่อไปนี้
-- ถ้าสอนมากกว่า 5 วิชา ให้เพิ่มเงิน จำนวนครั้งที่สอน * 2000
-- ถ้าสอนมากกว่า 3 วิชา ให้เพิ่มเงิน จำนวนครั้งที่สอน * 1000
-- ถ้าสอนมากกว่า 1 วิชา ให้เพิ่มเงิน จำนวนครั้งที่สอน * 500
SELECT  *
FROM    LECTURER

UPDATE  LECTURER
set     salary = salary +   amount * (case
                                when amount > 5 then 2000
                                when amount > 3 then 1000
                                when amount > 1 then 500
                                else  0
                            end)
FROM    LECTURER, LEC_TCH

SELECT  *
FROM    LECTURER



