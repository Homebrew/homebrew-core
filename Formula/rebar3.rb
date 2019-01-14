class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.8.0.tar.gz"
  sha256 "fc4d08037d39bcc651a4a749f8a5b1a10b2205527df834c2aee8f60725c3f431"

  bottle do
    cellar :any_skip_relocation
    sha256 "542fcbd0cbd88f776c01fb78ada4ef6444b58a3607e48acc27c6c2a7c99352ad" => :mojave
    sha256 "abca552b00a655e68a5aaa833d9e9fddc002a8c2fe720346b9edacd58e4617dd" => :high_sierra
    sha256 "76fc5c46356cd2824bca3599dfef8b8edfb2351d2a466c9e8ea5527d69620fa2" => :sierra
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
