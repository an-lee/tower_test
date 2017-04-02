# README

## 路由设置

### 团队

/teams

/teams/:id

## 项目

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

### 动态

/teams/:team_id/events



## Fundamental

安装必要的 gems：bootstrap, simple_form, devise



## step1

- 安装 rspect；
- project 模型
  - title
  - description
  - user_id
- team 模型
  - title
  - description
  - user_id
- access 模型
  - user_id
  - project_id
- todo 模型
  - title
  - due
  - user_id
  - assign