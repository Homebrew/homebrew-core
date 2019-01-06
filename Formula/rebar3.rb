class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.8.0.tar.gz"
  sha256 "fc4d08037d39bcc651a4a749f8a5b1a10b2205527df834c2aee8f60725c3f431"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ade58b33f27e1ef6b594321dd7c8db53f162afc51505fded481ab0fac1419ef" => :mojave
    sha256 "90fa4319b8e52c177f5c5332a606e92a838bf075e03cac7d4b5af41367665049" => :high_sierra
    sha256 "f9de452c6d3af305955c2ea87a4dfa61b267538074b6e29782e78ca12cc10794" => :sierra
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
