class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.9.1.tar.gz"
  sha256 "b7330a67a8cb5d6fb3b53a3246208b7c2b248546bcf62ef71a9a27b1d541c2d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec96645555ee0adcfc6723a0ea66584a103c63369d2b6369f981949b0b3cd226" => :mojave
    sha256 "8efa7806e7d99e5929620d15237fa2d4bb3bdb7ab55e90537447d6179d7fd29c" => :high_sierra
    sha256 "47ea8194d6a211ab5aa3aa7c738e1d76287a316a9c22bca96cf020bee82d8255" => :sierra
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
