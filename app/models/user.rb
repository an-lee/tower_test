class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :projects
  has_many :teams
  has_many :accesses
  has_many :participated_projects, :through => :accesses, :source => :project

  def is_member_of?(project)
    participated_projects.include?(project)
  end

  def join!(project)
    participated_projects << project
  end

  def quit!(project)
    participated_projects.delete(project)
  end

end
