class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.3.tar.gz"
  sha256 "6194b738fb8a4a1bef6619220ca8acf4ed826d2febfe39c62ebd0ed6fb7d05a8"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68b9657015e37e5db014a38ae0aabcfb64d9edbfe560fe8f38431069ea1842d1" => :sierra
    sha256 "c0c1c434896346b14d10a8d244713bb32c4793d39d3cabe704c51052ece42bd7" => :el_capitan
    sha256 "752825614e65506b0b0376343eb0205025e904974edf255bbb48f834228e0019" => :yosemite
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
