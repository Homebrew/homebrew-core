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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428fe27effe929170a25f8a264b23aed6b2df8d4492f48d1bf6c8e52bd4dee63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be10eb4b18e099da77c5eee41aa24107876186dbdb6958673c35c1ebbedd118"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17151aa510303762cff34780c34464745f1551c7d04dfd2bc568d54939af733d"
    sha256 cellar: :any_skip_relocation, ventura:        "b06a667d2fa16df3c23b78bc38209623480730e14724b19f29472ffac0172926"
    sha256 cellar: :any_skip_relocation, monterey:       "3c92b9865dbe05302dba84137f77911d4fd70935aa08a73fa3dd562290c56057"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0f516ac6da5a6268209828217a732bbacfa40d72c6eb789deccbc3d50a8339a"
    sha256 cellar: :any_skip_relocation, catalina:       "62220af0fc653d4fa07ba816ca9c7d6d34414335a77e93c30249b6720d9896f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104183846eb43eabb519e987a303b9ba08983faa70ba0c3bce519079e9632caa"
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
