linux下安装
    git clone git://repo.or.cz/topgit.git
    cd topgit
    make
    make install
    make prefix=/usr    或者    sudo make prefix=/usr install

 常用命令
    tg help
    tg create t/feature [DEPS_branch1 DEPS_branch2 ...]     # t/feature 为要创建的分支名 ；DEPS_branch为新创建分支的依赖分支，不填的话，默认为当前分支
        填好.topmsg 信息，然后git add -u ；并最后提交git commit -m 'commitMSG' 创建完成
        撤销创建的分支
            删除项目根目录下的 .top* 文件，切换到master分支，然后执行 tg delete t/feature命令删除t/feature 分支及特性分支的基准分支refs/top-bases/t/feature
    tg info [t/branchname]      显示当前分支或指定的Topgit分支信息
    tg update [t/branchname]      用于更新分支，即从依赖的分支获取最新的提交合并到当前分支。同时在refs/top-bases/ 命名空间下的特性分支的基准分支也会更新
        从该命令的输出信息可以看出执行了两次分支合并操作，一次是针对refs/top-bases/t/feature引用指向的特性分支的基准分支，另外一次针对的是refs/heads/t/feature特性分支。
        如果有冲突，解决冲突，再提交
    tg summary      用于显示Topgit管理的特性分支的列表及各个分支的状态
        tg summary --deps   除了显示特性分支外，还会显示特性分支的依赖分支
        显示出的信息 代表的含义很重要
    tg remote
        git init --bare /path/to/repos/tgtest.git           在远程创建一个裸仓库
        git remote add origin /path/to/repos/tgtest.git     在本地添加上一步创建远程仓库的一个远程remote
        git push origin master                              在本地将当前版本库的master分支推送到刚刚创建的远程版本库
        tg remote --populate origin                         之后执行tg remote 命令为远程版本库添加额外的配置，以便该远程版本库能够跟踪Topgit分支
            执行了这条tg remote命令后，会在当前版本库的 .git/config 文件中添加设置（详情：自己看）
            切换topgit 的远程追踪（追踪不同的remote 主机）
        这时再执行tg summary 会看到分支前面都标记“l”，即本地提交比远程版本库的新
        tg push t/feature                                   执行tg push 命令将特性分支 t/feature 及其基准分支推送到远程版本库
        再来执行tg summary ，可以看到t/feature的标识变为“r”，即远程和本地同步
        tg push --all       ＃同时推送所有Topgit特性分支推送到远程版本库
    tg depend add NAME      tg depend 命令目前仅实现了为当前的Topgit特性分支增加新的依赖；将NAME加入到文件　.topdeps中，并将NAME分支指向该特性分支及特性分支的基准分支进行合并操作。
        注意：虽然Topgit可以检查到分支的循环依赖，但还是要注意合理的设置分支的依赖，合并重复的依赖
    tg base         用于显示特性分支的基准分支的提交ID（精简格式）
    tg delete [-f] NAME     用于删除Topgit特性分支及其对应的基准分支；默认只删除没有改动的分支，即标记为“0” 的分支，除非使用 -f 参数    
        此命令尚不能自动清除其分支中对删除分支的依赖，还需要手动调整 .topdeps 文件，删除对不存在的分支的依赖
    tg patch [-i | -w] [NAME]       通过比较特性分支及其基准分支的差异，显示该特性分支的补丁。  -i参数显示暂存区和基准分支的差异； -w参数显示工作区和基准分支的差异
    tg export
    tg import
    tg log
    tg mail
    tg files
    tg prev
    tg next
    # tg graph