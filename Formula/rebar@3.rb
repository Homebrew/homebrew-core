class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.5.0.tar.gz"
  sha256 "e95e9d1f2ce219f548d4f49ad41409af02069190f19e2b6717585eef6ee77501"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c518e9a34a4c39654e528f9a2d37b6e8608d60112fbbb8938184c9aa6ccd3d90" => :high_sierra
    sha256 "556cbac59214c367d34b87bcfbc8a54f3ec224b4ab8a53980c7a9b9231286b1b" => :sierra
    sha256 "423c4405e2669c0da57f963c41dfc806fdd889542f566c1ac10d1f4567c99e3b" => :el_capitan
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
