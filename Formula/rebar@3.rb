class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.1.tar.gz"
  sha256 "fa8b056c37ed3781728baf0fc5b1d87a31edbc5f8dd9b50a5d1ad92b0230e5dd"
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
