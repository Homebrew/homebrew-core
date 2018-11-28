class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.7.5.tar.gz"
  sha256 "46d9991c8af1dc85a1de8edc6618c3e6dc9c3de60c67e8139a98d2e4c2d047ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "82b739c175ff1c2da2e0044c38f06f2497bb79d75ec86540eddfefa9cece6ed2" => :mojave
    sha256 "b563b5f42863e331db0940532aad81dc8cd6e1d23ced1b5ba97931230456f7fd" => :high_sierra
    sha256 "5db9e60f56721ecbdac710b8d3c87f3ee0320a42d878831ae9a17991b23512b6" => :sierra
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
