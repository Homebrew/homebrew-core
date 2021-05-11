class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.15.1.tar.gz"
  sha256 "2d09eafee3b03a212886ffec08ef15036c33edc603a9cdde841876fcb3b25bba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f036ba3f725ef43b4a7ee18f5e1384411d9916a477dc88e1298b85b3867e6e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e2b1a22dce3f1bebc7b8825b6a1454ac4f37c68f85b821df52a56a908b46f38"
    sha256 cellar: :any_skip_relocation, catalina:      "e484c9b86f0997d0f060989ab437ef02168693fde15ae4ac45700f354f604046"
    sha256 cellar: :any_skip_relocation, mojave:        "72082c4fe351b34cf778f4e3acd59381c8c8d66477cfb495be84bd22532b1b70"
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "priv/shell-completion/bash/rebar3"
    zsh_completion.install "priv/shell-completion/zsh/_rebar3"
    fish_completion.install "priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
