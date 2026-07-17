class QueueEntriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create show confirmation confirm decline]
  before_action :set_queue_entry, only: %i[show confirmation confirm decline]
  before_action :ensure_owner!, only: %i[show confirmation confirm decline]

  def new
    @venue = Venue.find(params[:venue_id])
    @queue_entry = @venue.queue_entries.new
    return unless user_signed_in?

    @queue_entry.name = "#{current_user.first_name} #{current_user.last_name}"
    @queue_entry.phone_number = current_user.phone_number
  end

  def create
    @venue = Venue.find(params[:venue_id])
    @queue_entry = @venue.queue_entries.new(queue_entry_params)
    @queue_entry.user = current_user if user_signed_in?
    @queue_entry.status = :waiting

    if @queue_entry.save
      redirect_to confirmation_queue_entry_path(@queue_entry)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def confirmation
  end

  def confirm
    @queue_entry.update(status: :confirmed)
    redirect_to confirmation_queue_entry_path(@queue_entry)
  end

  def decline
    @queue_entry.update(status: :cancelled)
    redirect_to root_path
  end

  private

  def set_queue_entry
    @queue_entry = QueueEntry.find(params[:id])
  end

  def ensure_owner!
    return if @queue_entry.user.nil?

    redirect_to root_path, alert: "Non autorisé" unless @queue_entry.user == current_user
  end

  def queue_entry_params
    params.require(:queue_entry).permit(:party_size, :name, :phone_number)
  end
end
