class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.3.4.tar.gz"
  sha256 "43eb1461c6dcfd23a0c386570e6c2a876e06d2388bbc0f1f0c9c99e393aa2f0f"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb2277ac2b4fe241d519f26bc0748a82facb7349acc4178f6b34c7241f383fb9"
  end

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
    zsh_completion.install "contrib/zsh/_vagrant"
  end

  test do
    assert_match "-F _vagrant",
      shell_output("bash -c 'source #{bash_completion}/vagrant && complete -p vagrant'")
  end
end
