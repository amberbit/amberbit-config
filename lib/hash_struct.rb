require "ostruct"

# Defines HashStruct class, which is simply OpenStruct and has additional
# accessor mode via square brackets like hashes
class HashStruct < OpenStruct
  def [](key)
    self.send key unless key == nil
  end
end
