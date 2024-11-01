if package.loaded['elin_cmp_source'] then
  return
end

require('cmp').register_source('elin', require('elin_cmp_source').new())
