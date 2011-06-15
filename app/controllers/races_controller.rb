class RacesController < ApplicationController
  include RacePdfHelper
  before_filter :require_login, except: [:show, :index]
  
  def index
    @upcoming_races = db.view Race.by_time(startkey: Time.now.as_json)
  end
  
  def new
    @race = Race.new
  end
  
  def create
    @race = Race.new params[:race]
    @race.organizer_id = current_user.id
    if db.save @race
      scrape_runkeeper_map @race
      redirect_to @race
    else
      render 'new'
    end
  end
  
  def edit
    @race = db.load! params[:id]
  end
  
  def show
    @race = db.load! params[:id]
    respond_to do |format|
      format.html do
        if params[:show] == 'results'
          @results = @race.results
          render 'results' 
        else
          @runners = @race.runners
        end
      end
      format.pdf do
        render text: start_numbers_pdf(@race)
      end
    end
  end
  
  def update
    race = db.load params[:id]
    
    if params[:results]
      params[:results].each do |runner_id, time|
        race.runs.find{|run| run.runner_id == runner_id}.time = time
      end
      race.is_dirty
      redirect_to race_path(race, show: 'results'), notice: 'Results updated.'
    else
      race.attributes = params[:race]
      redirect_to race_path(race), notice: 'Race updated.'
    end
    db.save race
    scrape_runkeeper_map race
  end
  
  private
  
  def scrape_runkeeper_map(race)
    RUNKEEPER_MAP_QUEUE.push(race_id: race.id)
  end
end