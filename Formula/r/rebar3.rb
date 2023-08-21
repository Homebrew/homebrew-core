class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.22.1.tar.gz"
  sha256 "2855b5784300865d2e43cb7a135cb2bba144cf15214c619065b918afc8cc6eb9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4671100f75af91f44eefca07685f70373ce2221a62fbc176f6ea40dd239a4112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26faa6b5dc3b69c39d0b3da9892d1f6850b03c91e9eb1eafc5fc96ec8e541060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d1caf760e3ce635a5dcb0f0d9abb0159257a170ef87466bd36322b24d0ff08e"
    sha256 cellar: :any_skip_relocation, ventura:        "f79bd43f7020e478b54fda92d8f6ab9cd95e69653113d5dcfae7f97138b6aaa6"
    sha256 cellar: :any_skip_relocation, monterey:       "f6cbae0a1d0eee241d0e20f8b4ab249b2962e9ae801ce176529e9ab61803ba78"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab3515d996438d3638a136e85ca6304d26d7eea41535f5a69d629e937aab460c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fad80111ef3b155c297d1109c3327dc7bc3cb8a7083cdb0c3345f18d9c7586ff"
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
