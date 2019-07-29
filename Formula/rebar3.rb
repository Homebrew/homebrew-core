class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.11.1.tar.gz"
  sha256 "a1822db5210b96b5f8ef10e433b22df19c5fc54dfd847bcaab86c65151ce4171"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ae127f15763c62a5f48d608791cbdf31cd6e2da28c1703c21bebf08cf949c34" => :mojave
    sha256 "bf0df47d8931348e04e216f6057368dac4410226f6faec2f28078051c5ec18f3" => :high_sierra
    sha256 "3c9d2f56f903b88e90134ab33de9eb46c27ce55ce9d9fa9f977abe0bcfe15d85" => :sierra
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
