# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is "Undercooked", a 2D cooking/restaurant game built with Godot 4.4. The game features order management, food collection, and a platformer-style movement system where players collect ingredients to fulfill customer orders.

## Development Environment

- **Engine**: Godot 4.4
- **Main Scene**: `new-game-project/game.tscn` (uid://cwbt82tcjayln)
- **Project Root**: `new-game-project/` directory
- **Rendering**: GL Compatibility mode with pixel-perfect rendering

## Key Scripts and Architecture

### Core Game Components

- **Player Controller**: `player.gd` - CharacterBody2D with platformer physics, item collection system, and ice/friction mechanics
- **Order System**: `order_display.gd` - Manages order generation, validation, and UI display for customer orders
- **Item Collection**: `item.gd` - Area2D pickup system for food items
- **Spawn Management**: `spawn_points.gd` - Handles food respawning and spawning logic
- **Menu System**: `Scripts/menu.gd` - Scene transitions between menu, game, tutorial, and options

### Scene Structure

- `menu.tscn` - Main menu with Play, Tutorial, Options, Exit buttons
- `game.tscn` - Main gameplay scene
- `tutorial.tscn` - Tutorial/help scene
- `options.tscn` - Settings/options scene
- Individual pickup scenes: `*_pickup.tscn` files for different food items

### Global Systems

- **Background Music**: Auto-loaded from `Assets/music/bgmusic.tscn`
- **Groups**: Player, Ice, Food groups for collision and interaction detection

## Asset Organization

- `Assets/` - All game assets including sprites, sounds, music, and fonts
- `Assets/Free_pixel_food_16x16/Icons/` - Food item sprites
- `Assets/MegasFoodPack-v1/` - Additional food sprites
- `Assets/music/` - Background music and audio
- `Assets/sounds/` - Sound effects
- `Assets/fonts/` - Custom pixel fonts (dogicapixel.ttf, PixelOperator8)

## Common Development Tasks

### Running the Game
- Open project in Godot Editor
- Set main scene to `new-game-project/game.tscn` if not already set
- Press F5 or use Play button

### Adding New Food Items
1. Create pickup scene using existing `*_pickup.tscn` as template
2. Add food sprite to `Assets/` directory
3. Update `order_display.gd` available_items array via inspector
4. Add to spawn points system in `spawn_points.gd`

### Order System Integration
- Orders are generated in `order_display.gd:generate_new_order()`
- Player inventory managed in `player.gd:items_collected` array
- Order checking handled by `order_display.gd:check_order()`
- New orders trigger respawn via `spawner.respawn()`

## Code Conventions

- GDScript follows standard Godot conventions
- Export variables for inspector configuration
- Signal-based UI interactions (`_on_button_pressed` pattern)
- Group-based entity management (Player, Ice, Food groups)
- Scene instancing for pickups and spawned objects

## Testing
- Playtest through Godot editor
- Test order generation and completion cycles
- Verify pickup spawning and respawning mechanics
- Test scene transitions from menu system