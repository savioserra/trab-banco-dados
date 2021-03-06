CREATE OR REPLACE FUNCTION AUTH(EMAIL VARCHAR(256), PASSWORD VARCHAR(512)) RETURNS UUID AS
$$
BEGIN
  RETURN (SELECT PROFILE_ID
          FROM PROFILE_CHARACTERISTICS
                 JOIN SCHEMA_CHARACTERISTICS SC ON PROFILE_CHARACTERISTICS.SCHEMA_CHARACTERISTIC_ID = SC.ID
                 JOIN USER_CHARACTERISTICS UC ON SC.CHARACTERISTIC_ID = UC.ID
                 JOIN PROFILES PROFILE ON PROFILE_CHARACTERISTICS.PROFILE_ID = PROFILE.ID
          WHERE CHARACTERISTIC_INFO = $1
             OR CHARACTERISTIC_INFO = $2
          GROUP BY PROFILE_ID
          HAVING COUNT(*) = 2);
END;
$$ LANGUAGE PLPGSQL;