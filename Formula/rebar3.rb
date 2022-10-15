class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.20.0.tar.gz"
  sha256 "53ed7f294a8b8fb4d7d75988c69194943831c104d39832a1fa30307b1a8593de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef92a8046c3586e56ea4dc2d06c2f4c820cdf089501fd3d7a23f7d88d3bf1d52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0f5455219769c8b3b161ab5513bb596cd10099d627c95914772d57f8f0d125a"
    sha256 cellar: :any_skip_relocation, monterey:       "0b30b3ae4f97383f843db7d700cbe035cfa4f4e0e29c925f8d27ea7786775a5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d39403a69b6be80a8393ee1f457a2f223744d3ef640a3fc5875ba0059a853c3"
    sha256 cellar: :any_skip_relocation, catalina:       "38ac0151429d49ee6317c7dfa80a7ff210fd3c346b0828900f02b8fa77ecc5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd5dc3126cebbd682d6f95911c0e433fdb43eaf0824f9b9aa2c28b93dbeef03"
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
