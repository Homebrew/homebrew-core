class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.2.16.tar.gz"
  sha256 "ab3c60bb12b2da916fd073192849f2b5d3f224f95febf3538212247c4cde28d6"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86892550f499bf4098dca6784245a7652f11dfdb9675b2af4e951f6d29d3068f"
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
