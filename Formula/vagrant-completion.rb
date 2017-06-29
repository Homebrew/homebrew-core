class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/mitchellh/vagrant"
  url "https://github.com/mitchellh/vagrant/archive/v1.9.6.tar.gz"
  sha256 "08cde24b5def90e7674d333149ca9d9aec585bdb54ca41598e16ea91a56675bb"

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
