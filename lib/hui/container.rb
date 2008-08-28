module Container
  def link(how, what)
    Link.new(@agent, how, what)
  end
  def links()
    @agent.page.links
  end
  def forms
    @agent.page.forms
  end
  def current_page
    @page = @agent.current_page
  end
  def get_html
    current_page.body
  end
  def submit()
    @agent.submit(IE.form)
  end
  def text_field(how, what)
    TextField.new(@agent, how, what)
  end
  def button(how, what)
    Button.new(@agent, how,what)
  end
  def check_box(how, what)
    CheckBox.new(@agent, how, what)
  end
  def radio_button(how, what)
    RadioButton.new(@agent, how, what)
  end
  def select_list(how, what)
    SelectList.new(@agent, how, what)
  end
  def text
    current_page.soup.to_s
  end
  def title
    current_page.title
  end  
end