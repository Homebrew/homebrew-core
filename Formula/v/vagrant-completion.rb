class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  # NOTE: Do not bump to new release as license changed to BUSL-1.1
  # https://github.com/hashicorp/vagrant/pull/13248
  url "https://github.com/hashicorp/vagrant/archive/v2.3.7.tar.gz"
  sha256 "fa8a96319aa7b9ff5f4a991b77cbf37f549549d84737624bcebefa8f2004bf45"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e505842b21fff086e13163e635da612316a8d1c3ef598744f773996c692ffa3"
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
