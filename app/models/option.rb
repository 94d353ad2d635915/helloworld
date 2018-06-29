class Option < ApplicationRecord
  enum autoload: instance_eval(OPTIONS['Option.autoloads'])
  # enum 代码改变 reload，production 环境，重启 rails 生效。
  # ActiveSupport::Dependencies.clear

  before_save {self.value = self.value.gsub(/\s/, '')}

  after_commit :options_update, on: [:create, :update]
  def options_update
    OPTIONS[self.name] = self.value
  end

  after_commit :options_delete, on: [:destroy]
  def options_delete
    OPTIONS.delete(self.name)
  end
end
