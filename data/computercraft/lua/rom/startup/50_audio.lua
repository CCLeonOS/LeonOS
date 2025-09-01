-- LeonOS Startup Music
local rc = ...
local peripheral = require("peripheral")
local speaker = peripheral.find("speaker")

-- 检查是否连接了扬声器
if speaker then
  -- 简单的开机音乐（C大调音阶）
  local notes = {
    {note = "C4", duration = 0.25},
    {note = "D4", duration = 0.25},
    {note = "E4", duration = 0.25},
    {note = "F4", duration = 0.25},
    {note = "G4", duration = 0.25},
    {note = "A4", duration = 0.25},
    {note = "B4", duration = 0.25},
    {note = "C5", duration = 0.5}
  }

  -- 播放音乐
  for _, note_info in ipairs(notes) do
    speaker.playNote(note_info.note)
    rc.sleep(note_info.duration)
  end
end