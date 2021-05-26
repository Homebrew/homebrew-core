class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.16.1.tar.gz"
  sha256 "a14711b09f6e1fc1b080b79d78c304afebcbb7fafed9d0972eb739f0ed89121b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "311325033f26ffaacec00c0be93013f8300526a026650ea9c210c8a04d72b6f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b259dfffab8a70ca1682ec495169a1b7cad0129a70e01b15dd483d00de70bacd"
    sha256 cellar: :any_skip_relocation, catalina:      "b819a3243b0d2a789ad00d3af48ce38309b030c9ced30d8c0c29823999f4bd77"
    sha256 cellar: :any_skip_relocation, mojave:        "1e9a3a46f448e7dd5c6b96f3690f31ec7de2949c7499a1d3b2cd8f9604f18b8a"
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
