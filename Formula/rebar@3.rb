class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.3.6.tar.gz"
  sha256 "2a3a6f709433a11e3fca51cc106b66e0941e7e7067bbc3f8364cbbad0b40660e"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97477955bbba01bdf2141696ee9791e8d332631f7bd2828c8727ef672c8b029f" => :sierra
    sha256 "990a382b8004f01fd1899e7963ffad7063786dffdaaeb9035e52b33a8e497923" => :el_capitan
    sha256 "dfa8383c85103558dc1284513996b3b4fe7cdba806a88dcc40a9a297b006300a" => :yosemite
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
