class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.2.15.tar.gz"
  sha256 "98c9c726d5cb7e46793b4505f3d907b2a0673e0f6e43997c218a0be5330cc83f"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git"

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
    zsh_completion.install "contrib/zsh/_vagrant"
  end

  test do
    assert_match "-F _vagrant",
      shell_output("source #{bash_completion}/vagrant && complete -p vagrant")
  end
end
