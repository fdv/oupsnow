module Admin
  class Functions < Application
    # provides :xml, :yaml, :js

    before :ensure_authenticated
    before :need_admin
  
    def index
      @functions = Function.all
      display @functions
    end
  
    def show(id)
      @function = Function.get(id)
      raise NotFound unless @function
      display @function
    end
  
    def new
      only_provides :html
      @function = Function.new
      display @function
    end
  
    def edit(id)
      only_provides :html
      @function = Function.get(id)
      raise NotFound unless @function
      display @function
    end
  
    def create(function)
      @function = Function.new(function)
      if @function.save
        redirect resource(:admin, :functions), :message => {:notice => "Function was successfully created"}
      else
        message[:error] = "Function failed to be created"
        render :new
      end
    end
  
    def update(id, function)
      @function = Function.get(id)
      raise NotFound unless @function
      if @function.update_attributes(function)
         redirect resource(:admin, @function)
      else
        display @function, :edit
      end
    end
  
    def destroy(id)
      @function = Function.get(id)
      raise NotFound unless @function
      if @function.destroy
        redirect resource(:functions)
      else
        raise InternalServerError
      end
    end
  
  end # Functions
end # Admin
