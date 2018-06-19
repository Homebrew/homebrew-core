class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.6.0.tar.gz"
  sha256 "f36d7ee852ccb0dfcfec9b495ff2a29015549410acb97bf0c2377b90d7064ed1"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efb2a5a1a9aac45b56191cf03ab3e07189680ff43cf67bbf0ac173ada18876c1" => :high_sierra
    sha256 "c8e69c08faac5d2695a52cefc28dd468b9d6cd96000215a107e8931db24ca55c" => :sierra
    sha256 "e5318b7547655600ee0c3d84c18047e88839d86ef1fc18fa127cd6373a3d10d3" => :el_capitan
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
