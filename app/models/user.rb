class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :projects
  has_many :teams
  has_many :todos
  has_many :events
  has_many :messages
  has_many :accesses
  has_many :team_relationships
  has_many :participated_projects, :through => :accesses, :source => :project
  has_many :participated_teams, :through => :team_relationships, :source => :team

  def is_member_of_proj?(project)
    participated_projects.include?(project)
  end

  def join_proj!(project)
    participated_projects << project
  end

  def quit_proj!(project)
    participated_projects.delete(project)
  end

  def is_member_of_team?(team)
    participated_teams.include?(team)
  end

  def join_team!(team)
    participated_teams << team
  end

  def quit_team!(team)
    participated_teams.delete(team)
  end

end
