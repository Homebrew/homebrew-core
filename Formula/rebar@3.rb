class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.7.tar.gz"
  sha256 "19b3d9cddef2e7eefcdf3ca66d1c649847c010edab4e0d2dbfa54161145a3d87"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6ffda5072a2a4c6af523e131bd90ed53862d1b16cf1afad776906eb3d2333fc" => :high_sierra
    sha256 "5cff9bdffab538306b04225b6916ae0a388867bce1c11a2b4864a68997be76f3" => :sierra
    sha256 "a7f9c45222902db6b1dea4eded353a6b3a41939eb558c4c90440bd19b7392a24" => :el_capitan
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
