class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.13.1.tar.gz"
  sha256 "706cc0770062bde2674abc01964c68553398fe4d8023605b305cfe326b92520f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f8ef0a741a5b40d2a0e33731d79cd97344d69b6d01a1a6cd4997ea0a22917cc" => :catalina
    sha256 "c0e7154c74dd0bdbea5d62817888a95fd6b272ee58464ccf46fe2224cb3dc027" => :mojave
    sha256 "93c2850e6ba9129450dbd57deaa14ca2fca6dd22caa741d5d9bd4fbd2020570b" => :high_sierra
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
