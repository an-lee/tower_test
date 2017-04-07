# README

本网站已部署至：https://tower-test.herokuapp.com/

测试账号1： test1@example.com （密码：111111）

测试账号2： test2@example.com （密码：111111）

测试账号3： test3@example.com （密码：111111）

## Model Rspec

### User Model

- has_many teams
- has_many projects
- has_many todos
- has_many messages
- has_many events
- has_many participated_teams
- has_many participated_projects

### Team Model

- 必须要有 title
- belongs_to user
- has_many projects
- has_many todos
- has_many events
- has_many team_relationship
- has_many members

### Project Model 

- 必须要有 title
- belongs_to user
- belongs_to team
- has_many todos
- has_many events
- has_many messages
- has_many accesses
- has_many members

### Todo Model

- 必须要有 title
- belongs_to user
- belongs_to team
- belongs_to project
- has_many messages
- has_many events

### Message Model 

- 必须要有 content
- belongs_to user
- belongs_to todo
- belongs_to project
- 新建 Message 时触发 event
  - action = "回复了任务"
  - action = "创建了讨论"

### Event Model 

- 必须要有 content
- belongs_to user
- belongs_to todo
- belongs_to project
- belongs_to team

## Controller Rspec

### Team Controller

- 登入才可以访问 #index
- 登入才可以新建团队 #new
- 新建团队自动成为该[团队成员] #create
- 团队必须要名字 #create / #update
- 加入团队才可以访问团队页面 #show
- [团队创建者]才可以编辑团队 #edit / #update
- [团队创建者]才可以删除团队 #destroy
- [非团队成员]可以加入团队 #join
- [团队成员]可以退出团队 #quit

### Project Controller

- 登入且是 **[团队成员]** 才可以新建项目 #new
- 新建项目组自动成为该[项目组成员] #create
- 项目必须要有名字 #create / # update
- [项目组成员]才可以访问项目页面 #show
- **<u>如果[团队管理员]非[项目组成员]，也不可访问项目页面</u>** #show
- [项目管理者]才可以编辑项目 #edit / #update
- [项目管理者]才可以删除项目 #destroy
- [团队成员]才可以加入项目组 #join
- [项目组成员]才可以退出项目组 #quit

### Todo Controller

- 任务必须要有名字 #create / #update
- [项目组成员]才可以新建任务 #new
  - 触发 event
    - action = "创建了任务"
- 任务必须要有名字 #create / # update
- [项目组成员]才可以访问任务页面 #show
- [项目组成员]才可以编辑任务 #edit
- [项目管理员/任务创建者]才可以删除/恢复任务 #trash / #untrash
  - 触发 event
    - action = "删除了任务"
    - action = "恢复了任务"
- [项目成员]才可以指派任务 #assign
  - 触发 event
    - action = "给 #{assign} 指派了任务"
    - action = "把 #{old_assign} 的任务指派给了 #{new_assign}"
- [项目成员]才可以设定任务完成时间 #due
  - 触发 event
    - action = "将任务完成时间从 没有截止日期 修改为 #{due}"
    - action = "将任务完成时间从 #{old_due} 修改为 #{new_due}"
- [项目成员]才可以标记完成状态 #complete / #uncomplete
  - 触发 event
    - action = "完成了任务"
    - action = "重新打开了任务"

### Message Controller

- [项目组成员]才可以新建评论 #new / #create
- 评论必须要有内容 #create / #update
- [项目管理员/评论作者]才可以删除评论 #destroy
- [评论作者]才可以编辑评论 #edit
- 评论分两类，归属于不同的页面
  - 任务级评论
  - 项目级讨论

### Event Controller

- 团队成员才可以访问该团队内的动态
- 团队成员只能看到自己参与项目的动态

## 路由设置

### 团队

/teams

/teams/:id

### 项目

/projects

/projects/:id

/teams/:team_id/projects

/teams/:team_id/projects/:id

### 任务

/projects/:project_id/todo

/projects/:project_id/todo/:id

### 评论

/projects/:project_id/messages

/projects/:project_id/messages/:id

/projects/:project_id/todos/:todo_id

### 动态

/teams/:team_id/events
