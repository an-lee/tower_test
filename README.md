# README

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

## step2

基础模型建设

- todo 模型
  - title
  - description
  - due
  - user_id
  - project_id
  - assign
- message 模型
  - title
  - content
  - user_id

## step3

- event 模型
  - action
    - [+] 创建了任务
    - [+] 删除了任务
    - [+] 完成了任务
    - [+] 恢复了任务
    - [+] 回复了任务
    - [+] 给 xxx 指派了任务
    - [+] 把 xxx 的任务指派给 xxx
    - [+]将任务完成时间从 xxx 修改为 xxx
  - user_id
  - team_id
  - todo_id
  - message_id
  - project_id

## step4

- user 对 project 的权限
- 增加 user.name
- 增加 event.category 以区分显示样式
- controllers 重构