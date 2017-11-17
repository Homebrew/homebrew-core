class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.6.tar.gz"
  sha256 "20e1bfc603b42171c10e0882eb75782c1ecd7f4361fdaea28adb2a97381a2523"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f39cf7e3d5f559e7e278c15f1377f005c322aac42876225bf6bca51155edd061" => :high_sierra
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
