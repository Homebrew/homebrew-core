class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.2.19.tar.gz"
  sha256 "4f0e6b1d466e26dead682c4d4843e8f64a012eba4be91506ae6c6d34d3d9c8f9"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d2e1d003d04ede074ccc7f12d497f378b5d32fe44e0163422d6cf8a0a8581e0"
  end

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
    zsh_completion.install "contrib/zsh/_vagrant"
  end

  test do
    assert_match "-F _vagrant",
      shell_output("/bin/bash -c 'source #{bash_completion}/vagrant && complete -p vagrant'")
  end
end
