# class ParticipationsController < ApplicationController
#   before_filter :require_user
#   
#   def destroy
#     participation = current_user.participations.find(params[:id])
#     participation.destroy
#     flash[:success] = 'You are no longer participating in this quiz'
#     redirect_to participation.quiz
#   rescue ActiveRecord::RecordNotFound
#     flash[:failure] = 'Participation not found'
#     redirect_to root_url
#   end
# end
