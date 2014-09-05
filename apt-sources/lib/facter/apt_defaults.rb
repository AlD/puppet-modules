require 'facter'
require 'yaml'

Facter.add(:apt_defaults) do
  setcode do
    r = {
      :debian => {   :release => 'stable',
                       :repos => [ '', 'updates', 'security'],
                  :components => [ 'main', 'contrib', 'non-free' ],
      },
      :ubuntu => {   :release => 'lucid',
                       :repos => [ '', 'updates', 'security'],
                  :components => [ 'main', 'universe', 'multiverse', 'restricted' ],
      },
    }

    # Hash.default can't be serialized, so...
    r[:default] = r[:ubuntu]

    # According to scope::lookupvar() the world consists of nothing but strings. String theory confirmed.
    YAML.dump(r)
  end
end
