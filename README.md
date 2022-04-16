# motd
Message of the day app for Windows networks, to display company news when logging in

This is a Delphi app I wrote for a national company that operated on a Windows Server domain / network. This app was called from the login script and displayed a window with the most recent news items, coming out of an SQL Server database with these fields - NewsItem, ItemDateTime, ItemAuthor, ItemHeadline, ItemText

The user could tick a box to say not to pop up again until there was new news; otherwise the app would display its window again on next login.

This was effective at the time, being a way of displaying company news to all staff at all sites.
