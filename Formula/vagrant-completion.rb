class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  url "https://github.com/hashicorp/vagrant/archive/v2.3.4.tar.gz"
  sha256 "43eb1461c6dcfd23a0c386570e6c2a876e06d2388bbc0f1f0c9c99e393aa2f0f"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "824412f7ee4b1706f62bbe41a07d58c5317a9af822b744b41d61c290be22fffc"
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
