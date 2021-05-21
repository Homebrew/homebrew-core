class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.16.0.tar.gz"
  sha256 "e0e4b78ef08995f1113a3264fb804683f5d7f21d431eb9c762a9557f153fcf70"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4ec56f22e12852c32b688dbe29749ae3090b90684f8d0db40c3282aee2a6362"
    sha256 cellar: :any_skip_relocation, big_sur:       "05e61f9f264ff44aea21a653f39d3a6f4dcea008aaf0e691f230c58d3202f1e5"
    sha256 cellar: :any_skip_relocation, catalina:      "fa630bcf6ba2addac3909ea34d401c48efc98b45629d7c8c87d8ddd8f4838e3d"
    sha256 cellar: :any_skip_relocation, mojave:        "5987b7d6f1de87a00c885645cb4a31818dedbb224c98c9bc5f50290c86fc38d9"
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
