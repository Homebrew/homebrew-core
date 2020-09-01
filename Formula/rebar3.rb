class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.14.0.tar.gz"
  sha256 "1e1a0d1d88d9b69311714eede8393a8a443cc53f9291755aa3c4da1f89a1132c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a3e0d373e2dd244b89478b684292c13653f70a88e1e808d2f636d8050504c6f5" => :catalina
    sha256 "40e2a7521a41345876e63f5426ff7be467bcc5331c47c0769b244a5e82834226" => :mojave
    sha256 "bdf484d6864b693b1f975b12d20cf4579259d6f905b4795a53006ad0587d5943" => :high_sierra
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
