class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.14.2.tar.gz"
  sha256 "19fcdc73debb90d405864f728e188cbc5b61c3939b911e58c0b59bf1619c4810"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2bb6e52f2a7a9ec29e7dc659092d8152635089891006a9c2e5a9dea742632ac4" => :big_sur
    sha256 "e2cb4c82c7efe1b1173f577e20f2fd095dac99a7441fae559d666df1b1f7377d" => :catalina
    sha256 "5d685653f64fd914b113a8a3ae7052a871154fb725265b0815535c9e2391dc50" => :mojave
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
