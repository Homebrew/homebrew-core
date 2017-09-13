class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.4.tar.gz"
  sha256 "0f7c860489dc4e4fcdc706a04690f791755870ff0e0582525b8ee9a78e911443"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "787c0ac553fb70f8c3622a318ec8ee0bbbc06d2a6027f2a67bcd77ef92e9b404" => :sierra
    sha256 "f474e27a03050b5a629b33fb5c3fb021a5c1e123de04aef953761ce51e8c7f01" => :el_capitan
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
