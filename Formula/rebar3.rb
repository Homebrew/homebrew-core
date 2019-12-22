class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.13.0.tar.gz"
  sha256 "49ecf89d04676d077712a10d8252bbda73998a3badf8b342481530fbc685a123"

  bottle do
    cellar :any_skip_relocation
    sha256 "c055b7e2ca208a93cf8862ebd233caa05331a5e2a982ba63020a1523eb1580ac" => :catalina
    sha256 "db2d4b74014e37acff3ca5776af8629b82ab7bf59dca7960c2740b3c18e93d8e" => :mojave
    sha256 "870f37bf9686025e4d6c983558663d86649d9008d9e1a46c63e1d75b77d95d92" => :high_sierra
    sha256 "06e094e77d05c814d1104b88a6daf372adb7b69adbd330267b3d22de4329641c" => :sierra
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
