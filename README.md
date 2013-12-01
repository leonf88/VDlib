
### 开发配置
Ubuntu环境下根据之前Blog所述安装ruby和rails开发环境，使用mysql作为数据库
通过bundle install更新相关配置文件。**这一过程在实际部署的时候需要考虑离线情况。**

### 测试部署
1. mysql 部署

    创建用户

        insert into mysql.user(Host,User,Password) values('localhost','dlib',password('123456'));
        flush privileges;
        
    创建数据库

        create database vdlib;
        flush privileges;
        grant all privileges on vdlib.* to dlib@localhost identified by '123456';
        flush privileges;

2. 初始化 rails 工程数据库

    设置 `config/database.yml` 中，socket参数。在 Ubuntu 环境下一般可以配置为
    
        socket: /var/run/mysqld/mysqld.sock
    
    在 CentOS 环境下，一般可以配置为
    
        socket=/var/lib/mysql/mysql.sock
        
    通过查看 mysql 的配置文件 `my.cnf` 可以知道在不同环境下的 `socket` 路径。然后，执行如下命令

        $ rake db:create RAILS_ENV=production (或者缺省表示 development)
        $ rake db:migrate RAILS_ENV=production (或者缺省表示 development)

3. 启动 test 服务

        $ rails server thin

4. 数据导入

        $ rails console
        irb(main):001:0> ld=LoadUtil.new
        irb(main):001:0> ld.videoImport('public/xls/video.sample.xls')

    修改 app/helpers/load_util.rb 中第108行，设置实际文档的路径

        irb(main):001:0> ld.docImport('public/xls/doc.sample.xls')

5. 搜索配置

        $ rake ts:index RAILS_ENV=production (或者缺省表示 development)
        
    在生成的 config/production.sphinx.conf 文件中加入
    
        indexer
        {
          mem_limit = 128M
        }
        index mem_core
        {
          ............
          charset_type = zh_cn.utf-8
          charset_dictpath = /usr/local/mmseg3/etc
        } 
    
    重新启动 rails 
    
        rake ts:reindex RAILS_ENV=production
        rake ts:start RAILS_ENV=production
    
### 网站设计与开发

#### a) 需求
* PC（或net方式） 在线浏览视频，浏览文档
* 统计用户登录信息
* 不提供视频和文字信息的更新
* 手机浏览视频
 
#### b) 难点
* 在线视频播放（flowplayer）
* 在线文档浏览（flexpaper）

#### c) 实现

##### c.1) 数据库设计

主要数据库包括文稿和影片资料两个部分，公共字段包括关键词标签、涉及的地点和资料整理人员，每个文稿都最多对应一个影片资料，每个影片可以对应多个文稿。

##### c.2) 用户管理

安装 devise：修改Gemfile，执行 `rails generate devise:install`，根据如下提示修改配置文件

===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here 
     is an example of default_url_options appropriate for a development environment 
     in config/environments/development.rb:

        config.action_mailer.default_url_options = { :host => 'localhost:3000' }

    In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root :to => "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:

       config.assets.initialize_on_precompile = false

     On config/application.rb forcing your application to not access the DB
     or load models when precompiling your assets.

  5. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================

 
### 参考文献

[在线文档预览解决方案][1]

[1]:http://hi.baidu.com/zchengqi/item/b981178146fa5ffcd1f8cd68

