require "puppet/util/execution"

Puppet::Type.type(:mysql_grant).provide(:default) do
  def create
    mysql "grant #{grants} on #{@resource[:database]}.* to '#{@resource[:username]}'@'#{@resource[:host]}'; flush privileges;"
  end

  def destroy
    mysql "revoke #{grants} on #{@resource[:database]}.* to '#{@resource[:username]}'@'#{@resource[:host]}'; flush privileges;"
  end

  def exists?
    output = mysql("show grants for #{@resource[:username]}@#{@resource[:host]}",
                   :combine => true, :failonfail => false)

    lines = output.split("\n")

    if lines.length > 1
      current_grants = grants_for_db(@resource[:database], lines)

      return false if current_grants.nil?
      return true  if current_grants == ['ALL PRIVILEGES']

      if Array(@resource[:grants]).all? { |g| current_grants.include?(g) }
        true
      else
        puts current_grants.inspect
        puts Array(@resource[:grants]).inspect
        false
      end
    else
      false
    end
  end

  def grants_for_db(db, arr)
    matching_grant = arr[1..-1].select { |line| line =~ / `#{db}`\.\* / }.first
    if matching_grant
      matching_grant.match(/^GRANT (.*) ON /)[1].split(",").map { |w| w.strip }
    else
      nil
    end
  end

  def grants
    [@resource[:grants]].flatten.join(", ")
  end

  def mysql(cmd, options = {})
    execute "#{@resource[:executable]} -u#{@resource[:mysql_user]} -h#{@resource[:mysql_host]} -p#{@resource[:mysql_port]} -u#{@resource[:mysql_user]} -e \"#{cmd}\" --password='#{@resource[:mysql_pass]}'", options
  end
end
