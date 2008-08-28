class Link
  def initialize(agent, how, what)
    @agent = agent
    @how, @what = how,what    
    @field = @agent.page.links.send(how, what)
  end  
  def click()
    raise "Element #{self.class} with #{@how} #{@what} is not found"  if @field.length == 0
    @agent.click(@field)
  end
end

class TextField
  def initialize(agent, how, what)
    @agent = agent
    @how, @what = how,what
    @agent.page.forms.each do |form|      
      if form.has_field?(what)
          @field = form.fields.send(how, what)
          Browser.form = form
          break
      else
      end   
    end
  end
  def set(text)
    raise "Element #{self.class} with #{@how} #{@what} is not found"  if @field.nil?
    @field.value = text
  end
end

class Button
  def initialize(agent, how, what)
    @agent = agent
    @how, @what = how,what
    @agent.page.forms.each do |form|
      form.buttons.each do |button|
        if button.send(how) == what
            @field = form.buttons.send(how, what)
            Browser.form = form
            break
        end
      end
    end      
  end
  def click()
    raise "Element #{self.class} with #{@how} #{@what} is not found"  if @field.nil?
    @agent.submit(Browser.form, @field)
  end
end

class CheckBox
  def initialize(agent, how, what)
    @agent = agent
    @how, @what = how,what
    @agent.page.forms.each do |form|
      form.checkboxes.each do |checkbox|
        if checkbox.send(how) == what
          Browser.form = form
          @field = form.checkboxes.send(how, what)
          break
        end
      end
    end  
  end
  def set(value)
    raise "Element #{self.class} with #{@how} #{@what} is not found"  if @field.nil?
    case value
      when "ON","On","on","oN"
        @field.check(true)
      when "OFF","Off","off"
        @field.check(false)
    end
  end
  def checked?
    @checkbox.checked
  end
end


class RadioButton
  def initialize(agent, how, what)
    @agent = agent
    @how, @what = how,what
    @agent.page.forms.each do |form|
      form.radiobuttons.each do |radio|
        if radio.send(how) == what
          @field = form.radiobuttons.send(how, what)
          Browser.form = form
          break
        end
      end
    end  
  end
  def set(value)
    raise "Element #{self.class} with #{@how} #{@what} is not found"  if @field.nil?
    case value
      when "ON","On","on","oN"
        @field.check
      when "OFF","Off","off"
        @field.ukcheck
    end
  end
  def checked?
    @field.checked
  end  
end


class SelectList
  extend Forwardable
  def initialize(agent, how, what)
    @field = TextField.new(agent, how, what)
    @how, @what = how,what
  end
  def_delegator :@field, :set, :select
end

def initialize_element()
end
