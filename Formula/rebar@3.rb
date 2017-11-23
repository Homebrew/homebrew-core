class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.7.tar.gz"
  sha256 "19b3d9cddef2e7eefcdf3ca66d1c649847c010edab4e0d2dbfa54161145a3d87"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "006503dff9340cdeb2daeadcfb09d48be4ae39ef684a800d6830aec3e849c3b5" => :high_sierra
    sha256 "4b3936ab1f32fbcc329b7b3c14e15e2288fecca75b93ab5ebc8e6eb9bcd84011" => :sierra
    sha256 "02e8b5c392b1ff466da1a51a7d92abecd9b43eba695577ebe556c6e1593520e5" => :el_capitan
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
