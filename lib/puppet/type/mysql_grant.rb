Puppet::Type.newtype(:mysql_grant) do
  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam :name do
    # just used to avoid dupes on database param
    isnamevar
  end

  newparam :database do
    validate do |v|
      unless v.is_a?(String)
        raise Puppet::ParseError, "mysql_grant#database must be a string!"
      end

      if v.empty?
        raise Puppet::ParseError, "mysql_grant#database must be a non-empty string!"
      end
    end
  end

  newparam :username do
    validate do |v|
      unless v.is_a?(String)
        raise Puppet::ParseError, "mysql_grant#username must be a string!"
      end

      if v.empty?
        raise Puppet::ParseError, "mysql_grant#username must be a non-empty string!"
      end
    end
  end

  newparam :grants do
    validate do |v|
      return true if v.is_a?(String) && v.length > 0
      return true if v.is_a?(Array) && v.length > 0 && v.all? { |e| e.is_a?(String) && e.length > 0 }

      raise Puppet::ParseError, "mysql_grant#grants must be an array of strings or a string"
    end
  end

  newparam :host do
    defaultto "localhost"
  end

  newparam :mysql_user do
    defaultto "root"
  end

  newparam :mysql_pass do
    defaultto ""
  end

  newparam :mysql_host do
    defaultto "localhost"
  end

  newparam :mysql_port do
    defaultto "3306"
  end

  newparam :executable do
    defaultto "/opt/boxen/homebrew/bin/mysql"
  end
end
