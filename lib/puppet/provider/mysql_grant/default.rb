require "puppet/util/execution"

Puppet::Type.type(:mysql_grant).provide(:default) do
  def create
    mysql "grant #{grants} on #{@resource[:database]}.* to '#{@resource[:username]}'@'#{@resource[:host]}'; flush privileges;"
  end

  def destroy
    mysql "revoke #{grants} on #{@resource[:database]}.* to '#{@resource[:username]}'@'#{@resource[:host]}'; flush privileges;"
  end

  def exists?
    output = mysql "show grants for #{@resource[:username]}@#{@resource[:host]}"

    lines = output.split("\n")

    if lines.length > 1
      current_grants = grants_for_db(@resource[:database], lines)

      if @resource[:grants].sort == current_grants.sort
        true
      else
        false
      end
    else
      false
    end
  end

  def grants_for_db(db, arr)
    matching_grant = arr[1..-1].select { |line| line =~ / `#{db}`\.\* / }.first
    matching_grant.match(/^GRANT (.*) ON /)[1].split(",").map { |w| w.chomp }
  end

  def grants
    [@resource[:grants]].flatten.join(", ")
  end

  def mysql(cmd)
    execute "mysql -u#{@resource[:mysql_user]} -h#{@resource[:mysql_host]} -p#{@resource[:mysql_port]} -u#{@resource[:mysql_user]} -e \"#{cmd}\" --password='#{@resource[:mysql_pass]}'"
  end
end
