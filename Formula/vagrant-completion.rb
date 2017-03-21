class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/mitchellh/vagrant"
  url "https://github.com/mitchellh/vagrant/archive/v1.9.2.tar.gz"
  sha256 "53723eec1180ed0e89c1968e06626c6d45e42f6dc25ae9934ca8dfc240a82046"

  head "https://github.com/mitchellh/vagrant.git"

  bottle :unneeded

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
  end

  test do
    assert_match "-F _vagrant",
      shell_output("source #{bash_completion}/vagrant && complete -p vagrant")
  end
end
