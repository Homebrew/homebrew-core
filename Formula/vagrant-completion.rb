class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.0.4.tar.gz"
  sha256 "fe15462221721b84165052669b5d4182987674c4b4aed2a4082e068dd8419b11"

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
