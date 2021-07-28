class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.2.18.tar.gz"
  sha256 "3508b0906b832d7317c8d36220798ec274b721e7ef63d0cf991c68f19d9dae90"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53de835d380914ef8fd1d99e922f965bce477edbf8701a0da9c900a7b2f71c69"
  end

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
    zsh_completion.install "contrib/zsh/_vagrant"
  end

  test do
    assert_match "-F _vagrant",
      shell_output("source #{bash_completion}/vagrant && complete -p vagrant")
  end
end
