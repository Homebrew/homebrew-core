class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.6.1.tar.gz"
  sha256 "40b3c85440f3235c7b149578d0211bdf57d1c66390f888bb771704f8abc71033"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e456bf255e7e2555a47f13cbc880f7f9f74bc094b1200c3a8d3f14263720af2" => :mojave
    sha256 "f05c4808e13a18f6670a7f57a5f5b7dbeb85d528881c41a62f80998b57b56d82" => :high_sierra
    sha256 "e8019293528b825fa3cae8d43ef08d42cc4864a24921aec510e68a054e4749bf" => :sierra
    sha256 "2355b23bc209911c1154c1f0a80b2a7e474dcb9959e612bf145b278e1ea930dc" => :el_capitan
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
