Few notes:
- ‼️ Do NOT use real-life email and passwords ‼️
- I've added admin user to the DB manually that can create other admins - email: admin@a.com pass: 123456
- I've used code formatting that we used to have in my previous job. It might look strange but I really like it. The idea is mainly to not have longer lines that 120 symbols. Could hvae gone with less too (we had limit of 100). I am fine with any kind of formating and naming tho :)
- During development I've encountered a couple of bugs that required me to wipe and recreate the DB. I think it's ok now but if anything happens pls tell and I will reset the DB again. (I wanted to add in app buttons to do that but it was more work that I didn't have time for)
- I've tested the app for regular sized phones, in my case - iPhone 16, and 16 pro. So it's not optimised for iPad or small screen devices.
- I've used Force unwraps '!' in a bit of places but I think they are either safe or it's better to crash in that particular case and know something is wrong than continue with faulty state unknowingly.

There are some things I wanted to do but didn't have time for:
- Factory pattern for VC + VM and move their creation from the coordinators
- Better text input validation, for example in registration and login
- Caching
- Users pagination
- A lot more testing
- Admin editing Users logic
- Optimize the app for all screen sizes
- Better UI
