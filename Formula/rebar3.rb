class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.12.0.tar.gz"
  sha256 "8ac45498f03e293bc6342ec431888f9a81a4fb9e1177a69965238d127c00a79e"

  bottle do
    cellar :any_skip_relocation
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
