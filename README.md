Tarakotta
=========

A fast-paced game of physics and territory, with multiple modes.

The rules are really simple.

 * Each player can claim towers by touching them
 * Touching a tower also refills its ammo
 * Towers shoot at all "intruders" within a certain radius.
 * Players get a point per second for every tower in their color.

As you might expect, in order to succeed, you have to find a balance between maintaining a tight line of defense, attacking the enemy, and broadening your horizons with the easy pickings of neutral towers, while dodging enemy bullets to run down enemy tower ammo. It's very notable and deliberate that the *only* way to fight your opponent is indirectly, through towers.

This game is a very early, very rough work in progress. Even the basic mechanics are under construction.

Running the game
================

It's still too early to bother packaging this game in any way, even via a makefile that users run themselves. This game is written in Love2D. For general instructions, [follow the official Love2D wiki](https://love2d.org/wiki/Getting_Started), but on UNIX-y systems this is as simple as:

    # install love2d, for example on Debian:
    sudo apt-get install love

    # From within this repository:
    love .

TODO
====

 * Bug: towers continue to fire at you, even if you die and respawn out of range
 * Spawn: Respawn animation that delays your ability to get back into the fight, but only slightly
 * Spawn: Respawn in an area, rather than a single point
 * Wall: wrap type
 * Modes: Soccer
 * Modes: Campaign
 * Main menu
