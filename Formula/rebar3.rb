class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.22.0.tar.gz"
  sha256 "28b256038b445ec818d2cc33000b3217f42a946219ede55ab5970503bfcf6647"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eab1d6a772d460fc9d97933b173123ebb0c9cecf15de1daa3024af8d983b2150"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed52ccd16079c79ac55885a1e9f88e6b01fccb1b64941e57326d4861bc650e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3b77b3ad4bb436efe07ebeef78cacd7e9b851eddb81d73f05aae3a7573e256d"
    sha256 cellar: :any_skip_relocation, ventura:        "c52c7648d0e04fcbd911a58bcf2b8ed28cf2c0ff7048d9e1527871dfce7bbcc5"
    sha256 cellar: :any_skip_relocation, monterey:       "51ed0f2f1cfe8ec49e0d72afcfe3c5930ccc48d29d38b6a996a7a76e37f7d0bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc4903f96c219d7abd4a374f01aee030e0a2601dc640abe0855e690254e8af98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6545152988f17d28c9c0c424910086a60f752226c8f55596e0ec06ee56e3aadc"
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
