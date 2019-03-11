-- Usually run after restoring database
select * from userinfo
-- Guest is usually not enabled
update userinfo set Enable = 1 where enable = 0 and ID not in ('Guest')
