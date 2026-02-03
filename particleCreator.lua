local particleCreator = {}

function particleCreator.createParticle(particleParameters)
  local is_emitter = (particleParameters.emitter_duration ~= nil) or (particleParameters.emit_freq ~= nil) or (particleParameters.particle_duration ~= nil)

  local pos = {}
  if (particleParameters.pos ~= nil) then
    pos = {
      x = (particleParameters.pos.x ~= nil and particleParameters.pos.x) or (particleParameters.x ~= nil and particleParameters.x) or 0,
      y = (particleParameters.pos.y ~= nil and particleParameters.pos.y) or (particleParameters.y ~= nil and particleParameters.y) or 0,
      z = (particleParameters.pos.z ~= nil and particleParameters.pos.z) or (particleParameters.z ~= nil and particleParameters.z) or 0
    }
  else
    pos = {
      x = (particleParameters.x ~= nil and particleParameters.x) or 0,
      y = (particleParameters.y ~= nil and particleParameters.y) or 0,
      z = (particleParameters.z ~= nil and particleParameters.z) or 0
    }
  end

  local duration = (particleParameters.duration ~= nil and particleParameters.duration) or (particleParameters.particle_duration ~= nil and particleParameters.particle_duration) or 1.5

  local velocity = {}
  if (particleParameters.velocity ~= nil) then
    velocity = {
      x = (particleParameters.velocity.x ~= nil and particleParameters.velocity.x) or (particleParameters.velocity_x ~= nil and particleParameters.velocity_x) or 0,
      y = (particleParameters.velocity.y ~= nil and particleParameters.velocity.y) or (particleParameters.velocity_y ~= nil and particleParameters.velocity_y) or 0,
      z = (particleParameters.velocity.z ~= nil and particleParameters.velocity.z) or (particleParameters.velocity_z ~= nil and particleParameters.velocity_z) or 0
    }
  else
    velocity = {
      x = (particleParameters.velocity_x ~= nil and particleParameters.velocity_x) or 0,
      y = (particleParameters.velocity_y ~= nil and particleParameters.velocity_y) or 0,
      z = (particleParameters.velocity_z ~= nil and particleParameters.velocity_z) or 0
    }
  end

  local size = {}
  if (particleParameters.size ~= nil) then
    if (type(particleParameters.size) == "number") then
      size = {
        x = particleParameters.size,
        y = particleParameters.size,
        z = particleParameters.size
      }
    else
      size = {
        x = (particleParameters.size.x ~= nil and particleParameters.size.x) or (particleParameters.size_x ~= nil and particleParameters.size_x) or 0.1,
        y = (particleParameters.size.y ~= nil and particleParameters.size.y) or (particleParameters.size_y ~= nil and particleParameters.size_y) or 0.1,
        z = (particleParameters.size.z ~= nil and particleParameters.size.z) or (particleParameters.size_z ~= nil and particleParameters.size_z) or 0.1
      }
    end
  else
    size = {
      x = (particleParameters.size_x ~= nil and particleParameters.size_x) or 0.1,
      y = (particleParameters.size_y ~= nil and particleParameters.size_y) or 0.1,
      z = (particleParameters.size_z ~= nil and particleParameters.size_z) or 0.1
    }
  end

  local size_end = (particleParameters.size_end ~= nil and particleParameters.size_end or 1)

  local start_color = {}
  if (particleParameters.start_color ~= nil) then
    start_color = {
      r = (particleParameters.start_color.r ~= nil and particleParameters.start_color.r) or (particleParameters.start_color_r ~= nil and particleParameters.start_color_r) or 255,
      g = (particleParameters.start_color.g ~= nil and particleParameters.start_color.g) or (particleParameters.start_color_g ~= nil and particleParameters.start_color_g) or 255,
      b = (particleParameters.start_color.b ~= nil and particleParameters.start_color.b) or (particleParameters.start_color_b ~= nil and particleParameters.start_color_b) or 255,
      a = (particleParameters.start_color.a ~= nil and particleParameters.start_color.a) or (particleParameters.start_color_a ~= nil and particleParameters.start_color_a) or 255
    }
  else
    start_color = {
      r = (particleParameters.start_color_r ~= nil and particleParameters.start_color_r) or 255,
      g = (particleParameters.start_color_g ~= nil and particleParameters.start_color_g) or 255,
      b = (particleParameters.start_color_b ~= nil and particleParameters.start_color_b) or 255,
      a = (particleParameters.start_color_a ~= nil and particleParameters.start_color_a) or 255
    }
  end

  local gravity = (particleParameters.gravity ~= nil and particleParameters.gravity or 0)
  local rotation = (particleParameters.rotation ~= nil and particleParameters.rotation or 0)

  local velocity_var = {}
  if (particleParameters.velocity_var ~= nil) then
    velocity_var = {
      x = (particleParameters.velocity_var.x ~= nil and particleParameters.velocity_var.x) or (particleParameters.velocity_var_x ~= nil and particleParameters.velocity_var_x) or 0,
      y = (particleParameters.velocity_var.y ~= nil and particleParameters.velocity_var.y) or (particleParameters.velocity_var_y ~= nil and particleParameters.velocity_var_y) or 0,
      z = (particleParameters.velocity_var.z ~= nil and particleParameters.velocity_var.z) or (particleParameters.velocity_var_z ~= nil and particleParameters.velocity_var_z) or 0
    }
  else
    velocity_var = {
      x = (particleParameters.velocity_var_x ~= nil and particleParameters.velocity_var_x) or 0,
      y = (particleParameters.velocity_var_y ~= nil and particleParameters.velocity_var_y) or 0,
      z = (particleParameters.velocity_var_z ~= nil and particleParameters.velocity_var_z) or 0
    }
  end

  local end_color = {}
  if (particleParameters.end_color ~= nil) then
    end_color = {
      r = (particleParameters.end_color.r ~= nil and particleParameters.end_color.r) or (particleParameters.end_color_r ~= nil and particleParameters.end_color_r) or 255,
      g = (particleParameters.end_color.g ~= nil and particleParameters.end_color.g) or (particleParameters.end_color_g ~= nil and particleParameters.end_color_g) or 255,
      b = (particleParameters.end_color.b ~= nil and particleParameters.end_color.b) or (particleParameters.end_color_b ~= nil and particleParameters.end_color_b) or 255,
      a = (particleParameters.end_color.a ~= nil and particleParameters.end_color.a) or (particleParameters.end_color_a ~= nil and particleParameters.end_color_a) or 255
    }
  else
    end_color = {
      r = (particleParameters.end_color_r ~= nil and particleParameters.end_color_r) or 255,
      g = (particleParameters.end_color_g ~= nil and particleParameters.end_color_g) or 255,
      b = (particleParameters.end_color_b ~= nil and particleParameters.end_color_b) or 255,
      a = (particleParameters.end_color_a ~= nil and particleParameters.end_color_a) or 255
    }
  end

  local emit_pos_var = {}
  if (particleParameters.emit_pos_var ~= nil) then
    emit_pos_var = {
      x = (particleParameters.emit_pos_var.x ~= nil and particleParameters.emit_pos_var.x) or (particleParameters.emit_pos_var_x ~= nil and particleParameters.emit_pos_var_x) or 0,
      y = (particleParameters.emit_pos_var.y ~= nil and particleParameters.emit_pos_var.y) or (particleParameters.emit_pos_var_y ~= nil and particleParameters.emit_pos_var_y) or 0,
      z = (particleParameters.emit_pos_var.z ~= nil and particleParameters.emit_pos_var.z) or (particleParameters.emit_pos_var_z ~= nil and particleParameters.emit_pos_var_z) or 0
    }
  else
    emit_pos_var = {
      x = (particleParameters.emit_pos_var_x ~= nil and particleParameters.emit_pos_var_x) or 0,
      y = (particleParameters.emit_pos_var_y ~= nil and particleParameters.emit_pos_var_y) or 0,
      z = (particleParameters.emit_pos_var_z ~= nil and particleParameters.emit_pos_var_z) or 0
    }
  end

  local emit_pos_offset = {}
  if (particleParameters.emit_pos_offset ~= nil) then
    emit_pos_offset = {
      x = (particleParameters.emit_pos_offset.x ~= nil and particleParameters.emit_pos_offset.x) or (particleParameters.emit_pos_offset_x ~= nil and particleParameters.emit_pos_offset_x) or 0,
      y = (particleParameters.emit_pos_offset.y ~= nil and particleParameters.emit_pos_offset.y) or (particleParameters.emit_pos_offset_y ~= nil and particleParameters.emit_pos_offset_y) or 0,
      z = (particleParameters.emit_pos_offset.z ~= nil and particleParameters.emit_pos_offset.z) or (particleParameters.emit_pos_offset_z ~= nil and particleParameters.emit_pos_offset_z) or 0
    }
  else
    emit_pos_offset = {
      x = (particleParameters.emit_pos_offset_x ~= nil and particleParameters.emit_pos_offset_x) or 0,
      y = (particleParameters.emit_pos_offset_y ~= nil and particleParameters.emit_pos_offset_y) or 0,
      z = (particleParameters.emit_pos_offset_z ~= nil and particleParameters.emit_pos_offset_z) or 0
    }
  end

  if (is_emitter) then
    local emitter_duration = (particleParameters.emitter_duration ~= nil and particleParameters.emitter_duration or 60)
    local emit_freq = (particleParameters.emit_freq ~= nil and particleParameters.emit_freq or 1)

    add_particle_emitter(pos.x, pos.y, pos.z, emitter_duration, emit_freq, duration, velocity.x, velocity.y, velocity.z, size.x, size.y, size.z, size_end, start_color.r, start_color.g, start_color.b, start_color.a, gravity, rotation, velocity_var.x, velocity_var.y, velocity_var.z, end_color.r, end_color.g, end_color.b, end_color.a, emit_pos_var.x, emit_pos_var.y, emit_pos_var.z, emit_pos_offset.x, emit_pos_offset.y, emit_pos_offset.z)
    return
  end
  add_particle(pos.x, pos.y, pos.z, duration, velocity.x, velocity.y, velocity.z, size.x, size.y, size.z, size_end, start_color.r, start_color.g, start_color.b, start_color.a, gravity, rotation, velocity_var.x, velocity_var.y, velocity_var.z, end_color.r, end_color.g, end_color.b, end_color.a, emit_pos_var.x, emit_pos_var.y, emit_pos_var.z, emit_pos_offset.x, emit_pos_offset.y, emit_pos_offset.z)
end

return particleCreator