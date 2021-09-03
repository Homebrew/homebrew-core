class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.17.0.tar.gz"
  sha256 "4c7f33a342bcab498f9bf53cc0ee5b698d9598b8fa9ef6a14bcdf44d21945c27"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01ef700fd26e97906fcfff22eca55fd2699f836662547b49cd783a6747483fbc"
    sha256 cellar: :any_skip_relocation, big_sur:       "94c570851114c38bdf20407dd3ed443e7ae0003cfc70bedfb6e4aca4b97020cf"
    sha256 cellar: :any_skip_relocation, catalina:      "0c67a76dc37ad80d72d8320feb9d15b67b413eff4d2e4c058b1a6d524d8f8d88"
    sha256 cellar: :any_skip_relocation, mojave:        "abf392fe4bedf8a778a4db2e13e9e9b68e0f2e816376747916e4d9987c70a2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af9f371649f8bbbf30a5ddce23fe8d52428109adf8d927917336bcd5db692b1"
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
