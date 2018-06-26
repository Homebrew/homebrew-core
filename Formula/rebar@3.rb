class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.6.1.tar.gz"
  sha256 "40b3c85440f3235c7b149578d0211bdf57d1c66390f888bb771704f8abc71033"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "343a78e1de9bc95ce18006270e13ce7d0927c3d7125dac560ce10f11197aee19" => :high_sierra
    sha256 "5160e87d09683a66b42c862ab140849104a1bcaef4edd169562d637646e6e7d5" => :sierra
    sha256 "7c311bc4e348be64f3d547bf30ae5828783c9acd616fa323a825f15ee82bfcec" => :el_capitan
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
