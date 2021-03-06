# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = Event.all
    @upcoming = Event.upcoming
    @past = Event.past
    @current_user = current_user
  end

  def new
    @event = Event.new
    @current_user = current_user
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      redirect_to current_user
    else
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    @current_user = current_user
    @checked = (@current_user == @event.creator || @event.attendees.include?(@current_user)) && logged_in?
    @users = User.all
    @invitation = current_user.invitations.build if logged_in?
    @invited = @event.attendees
  end

  private

  def event_params
    params.require(:events).permit(:title, :description, :date)
  end
end
