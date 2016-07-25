Model = require 'activer'
Chunk = require './chunk.coffee'

class Job extends Model
  @belongsTo('Chunk')
  @attributes('type', 'params')

module.exports = Job
