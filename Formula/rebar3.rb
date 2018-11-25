class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.7.3.tar.gz"
  sha256 "d9bd4d7380427d11f8626bd48a7c61ff1fdb86c18ff16ce57875a82fdab98e3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "621c2575023e3d0ef249faca1124ed52b8d12ba8d98d463d2ae5a7a9c7ca1aec" => :mojave
    sha256 "fede005f82c081bdeeabce8a490b684698627dfc514ad95b75a882d57b0316da" => :high_sierra
    sha256 "cd9d824c891c57b2ab1fe1e78962f2a7e9f63fd566cdfc9d8685ca727840ef60" => :sierra
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
