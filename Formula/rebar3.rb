class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.14.3.tar.gz"
  sha256 "69024b30f17b52c61e5e0568cbf9a2db325eb646ae230c48858401507394f5c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "39fe38be9b648ad395ae221e1cc6e36ea19e70f1bd36e96e2329f2985e23b2a2" => :big_sur
    sha256 "9435773478bd827406624661c61bbd684915d0211fdfc4561534a71a35dc586b" => :arm64_big_sur
    sha256 "a05ca90daf365ebae8b5970613e1bfed5b95cf7ab5f37673bd17f8595dc277fc" => :catalina
    sha256 "a3184b782e3ca3b814d6a75641272ad2737492bfdaa6bd63225b1a1655c937af" => :mojave
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
