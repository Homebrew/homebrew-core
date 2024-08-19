class VagrantCompletion < Formula
  desc "Bash completion for Vagrant"
  homepage "https://github.com/hashicorp/vagrant"
  # NOTE: Do not bump to new release as license changed to BUSL-1.1
  # https://github.com/hashicorp/vagrant/pull/13248
  url "https://github.com/hashicorp/vagrant/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "fa8a96319aa7b9ff5f4a991b77cbf37f549549d84737624bcebefa8f2004bf45"
  license "MIT"
  head "https://github.com/hashicorp/vagrant.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b0d411d4cb2f9c85c5f2fb8443dd25bcf8b7624c49019abf613ebd8caa38314f"
  end

  # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
  deprecate! date: "2023-09-27", because: "will change its license to BUSL on the next release"

  def install
    bash_completion.install "contrib/bash/completion.sh" => "vagrant"
    zsh_completion.install "contrib/zsh/_vagrant"
  end

  def caveats
    <<~EOS
      We will not accept any new Vagrant releases in homebrew/core (with the BUSL license).
      The next release will change to a non-open-source license:
      https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https://docs.brew.sh/License-Guidelines
    EOS
  end

  test do
    assert_match "-F _vagrant",
      shell_output("bash -c 'source #{bash_completion}/vagrant && complete -p vagrant'")
  end
end
