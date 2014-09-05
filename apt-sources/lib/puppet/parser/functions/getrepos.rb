require 'yaml'

module Puppet::Parser::Functions
  newfunction(:_getrepos, :type => :rvalue) do |args|
    distro, release, repos, components = args

    out = {}

    if repos
      repos.each { |repo|
        debug "Adding distro #{distro} release #{release} repo #{repo}"

        # puppet doesn't support nil, so check for empty repo
        name = [ release, repo[0] ? repo : nil ].compact.join("-")
        out["#{distro}-#{name}"] = { 'dist' => distro,
                                     'repo' => name,
                               'components' => components,
        }
      }
    end

    return out
  end

  newfunction(:getrepos, :type => :rvalue) do |args|
    # required to have _getrepos() available
    Puppet::Parser::Functions.autoloader.loadall
    distro, release, repos, components = args

    defaults = YAML.load(lookupvar('apt_defaults'))

    settings = case distro.downcase
      when 'debian'
        defaults[distro.downcase.to_sym]
      when 'ubuntu'
        defaults[distro.downcase.to_sym]
      else
        defaults[:default]
    end

    release    = release[0]            ? release    : settings[:release]
    repos      = repos.length > 0      ? repos      : settings[:repos]
    components = components.length > 0 ? components : settings[:components]

    info("Getting apt sources for Distro #{distro}, Release #{release} and Repos #{repos.join(', ')}.")

    function__getrepos([ distro, release, repos, components])
  end
end
