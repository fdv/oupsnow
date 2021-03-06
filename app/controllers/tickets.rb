class Tickets < Application
  # provides :xml, :yaml, :js
  
  before :projects
  before :ensure_authenticated, :exclude => [:index, :show]
  before :admin_project, :only => [:edit_main_description, 
                                    :update_main_description]

  params_accessible :ticket => [:title, :description, :tag_list, :member_assigned_id, :state_id, :priority_id]

  def index
    @tickets = Ticket.paginate(:project_id => @project.id,
                               :page => params[:page],
                               :per_page => 20)
    display @tickets
  end

  def show(project_id, ticket_permalink)
    @ticket = Ticket.get_by_permalink(project_id, ticket_permalink)
    raise NotFound unless @ticket
    display @ticket
  end

  def new(project_id)
    only_provides :html
    @ticket = Ticket.new(:project_id => project_id)
    display @ticket
  end

  def edit_main_description(project_id, ticket_permalink)
    only_provides :html
    @ticket = Ticket.get_by_permalink(project_id, ticket_permalink)
    raise NotFound unless @ticket
    display @ticket
  end

  def update_main_description(project_id, ticket_permalink, ticket)
    @ticket = Ticket.get_by_permalink(project_id, ticket_permalink)
    raise NotFound unless @ticket
    @ticket.description = ticket[:description]
    if @ticket.save
      redirect resource(@project, @ticket)
    else
      display @ticket
    end
  end

  def create(ticket)
    @ticket = Ticket.new(ticket)
    @ticket.project_id = @project.id
    @ticket.created_by = session.user
    if @ticket.save
      redirect resource(@project, @ticket), :message => {:notice => "Ticket was successfully created"}
    else
      message[:error] = "Ticket failed to be created"
      render :new
    end
  end

  def update(project_id, ticket_permalink, ticket)
    @ticket = Ticket.get_by_permalink(project_id, ticket_permalink)
    raise NotFound unless @ticket
    if @ticket.generate_update(ticket, session.user)
      redirect resource(@project, @ticket)
    else
      display @ticket, :show
    end
  end

end # Tickets
