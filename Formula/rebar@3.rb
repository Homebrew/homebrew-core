class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.6.1.tar.gz"
  sha256 "40b3c85440f3235c7b149578d0211bdf57d1c66390f888bb771704f8abc71033"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93810f629b55e7bb96b63596b98aa1914c0d06091c988af2b03a7ea33ee74fe8" => :high_sierra
    sha256 "f6316f92f20c6a266c412ac49ec731743f7b43afecc44939049802c45ebee4e4" => :sierra
    sha256 "461a1ba52650feef1ed4ef6d831cfacc752b126298565ac6b469d067740b7e3b" => :el_capitan
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
