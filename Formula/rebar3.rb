class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.19.0.tar.gz"
  sha256 "ff9ef42c737480477ebdf0dd9d95ece534a14c96f05edafbf32e9af973280bc3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44500038a7b9cd871f2ddba57cfa67d147abb833c6868cf72590a19b544fabee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70362076a1b5523e0c4e789840c30cee30c76b1399c957aba61ce47261594331"
    sha256 cellar: :any_skip_relocation, monterey:       "c8547511cfe4dfe1b5753d81218ad149d597f01961a5f6e41d1c989500897481"
    sha256 cellar: :any_skip_relocation, big_sur:        "b76334a1871767352db5e5e641c4cc6c02d0d291c6a16012cf7f2f999674f362"
    sha256 cellar: :any_skip_relocation, catalina:       "49f8019c79ba3b07f9a91a2aa66c9767f724ffd49a418dce80e9296628bf2202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e6def810bc61aaee09615d73e5692bfeb723070e4e6e28902b1ba822e97607"
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
