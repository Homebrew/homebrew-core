class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.10.0.tar.gz"
  sha256 "656b4a0bd75f340173e67a33c92e4d422b5ccf054f93ba35a9d780b545ee827e"

  bottle do
    cellar :any_skip_relocation
    sha256 "00ebeae3691b0f4f947d57d297bdf665666820d3487f467729e6d948dbfcdf20" => :mojave
    sha256 "85cc27859e1022b371afcabb0221910891a5430ac8ce77c99032d71bbcfe7385" => :high_sierra
    sha256 "93340e5b193c10dee122a694574e4e7ee05c770e44544da214fc7512b6134884" => :sierra
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
