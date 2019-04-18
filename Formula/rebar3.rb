class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.10.0.tar.gz"
  sha256 "656b4a0bd75f340173e67a33c92e4d422b5ccf054f93ba35a9d780b545ee827e"

  bottle do
    cellar :any_skip_relocation
    sha256 "00da5264fdfb7f7a1a1e4bf620e3e3bf4aad863c5ef44a9ebaaf7812aa8e7854" => :mojave
    sha256 "0168f1b8e24ecc01eda20b993c811f5310b7531bedc061a9f8580f5b557f21f6" => :high_sierra
    sha256 "ad821cf1468ef68c53904f001dfbcb965a73cd0189921c9ba43a496cee95b77a" => :sierra
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
