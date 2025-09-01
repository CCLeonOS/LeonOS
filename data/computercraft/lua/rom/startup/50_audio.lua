-- LeonOS Startup Music
local rc = ...
local peripheral = require("peripheral")
local speaker = peripheral.find("speaker")

-- 检查是否连接了扬声器
if speaker then
  -- 简单的开机音乐（C大调音阶）
  -- 格式: {instrument = 乐器, pitch = 音高(半音), duration = 持续时间}
  local notes = {
    {instrument = "harp", pitch = 6, duration = 0.25},  -- C4
    {instrument = "harp", pitch = 8, duration = 0.25},  -- D4
    {instrument = "harp", pitch = 10, duration = 0.25}, -- E4
    {instrument = "harp", pitch = 11, duration = 0.25}, -- F4
    {instrument = "harp", pitch = 13, duration = 0.25}, -- G4
    {instrument = "harp", pitch = 15, duration = 0.25}, -- A4
    {instrument = "harp", pitch = 17, duration = 0.25}, -- B4
    {instrument = "harp", pitch = 18, duration = 0.5}   -- C5
  }

  -- 播放音乐
  for _, note_info in ipairs(notes) do
    -- 播放音符，使用默认音量1.0
    speaker.playNote(note_info.instrument, 1.0, note_info.pitch)
    rc.sleep(note_info.duration)
  end
end