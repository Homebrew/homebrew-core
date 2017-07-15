class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.2.tar.gz"
  sha256 "f4d38d01671af6a7eb4777654d1543b42c873dad32046e444434c64d929fc789"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3333d0cada9ebf7dec90aec4ab82026c18df2ece9eab4a2a098776c2a5fd9f87" => :sierra
    sha256 "5aa3c2ad030e5a81ef5b814af6e2c8ca613b60b39ec0d9367f7aabcdb12deac8" => :el_capitan
    sha256 "019df9817d19c6565cfab70dd80897a8ff942ae7d17d9795cc6d75f9ca30b639" => :yosemite
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
