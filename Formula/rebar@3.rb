class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.5.3.tar.gz"
  sha256 "1bad3feb48b43cdd8bbe40d0a2763fe36e916320c214a0689587198f28e81649"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e32337f8f054a9b956c2cb72a2c55773b7e0ad8022421a7657912b356bebca75" => :high_sierra
    sha256 "d815e7fafab29b3c001949fa5a19b7da5f4517f1cf19c9d40f759b85c303ed06" => :sierra
    sha256 "7727d005cab3e46ba2b361a742cc5415c3a72409d41f03161c7b27a89df338fc" => :el_capitan
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
