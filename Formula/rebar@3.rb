class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.3.5.tar.gz"
  sha256 "b17661bedaf2060179e0b7b2c4a64350b7a303d809397325ee4be38cc1dc9058"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72164fa23dea1b2533bf4894d3c59231db5b9503ea27828dd66bc008de85d5fb" => :sierra
    sha256 "663aa691ffbf6c49d13d1a0fd7c51f27859ac3e9b5673aa961df5b9682dfa8df" => :el_capitan
    sha256 "e26e0b500939ac3eb9fcb54d9234def934624c241a3577438e8f71f99ec662ce" => :yosemite
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
