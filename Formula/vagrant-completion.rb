class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/mitchellh/vagrant"
  url "https://github.com/mitchellh/vagrant/archive/v1.9.8.tar.gz"
  sha256 "59c1d50437d2f50eeae219bc03c90d397fe8d8c974cce7c51b017b8ceeaefb54"

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
