class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.7.3.tar.gz"
  sha256 "d9bd4d7380427d11f8626bd48a7c61ff1fdb86c18ff16ce57875a82fdab98e3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1014079676fddd5a169739d3ce467983a0fae80a79eac44a8d8b37977d69e703" => :mojave
    sha256 "acb91ee6e196c7965402b2906240c4dfa1855a419a5d1c29a54e24c86342f5d1" => :high_sierra
    sha256 "dd76bca2bf61bd2ce0324dba7504a56dd090899b4c31998efa0c273d3b8ddf87" => :sierra
    sha256 "5f8cb011087b823463a7008754f7fcbc74753e9e9a9176cb1251c73fc89fbe8d" => :el_capitan
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
