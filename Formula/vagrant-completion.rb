class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.1.1.tar.gz"
  sha256 "8b54b39ad2bdfe038f5a6767a745f2139d6f62e6e4745008e906f2e1c658fa4d"

  head "https://github.com/hashicorp/vagrant.git"

  bottle :unneeded

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
  end

  test do
    assert_match "-F _vagrant",
      shell_output("source #{bash_completion}/vagrant && complete -p vagrant")
  end
end
