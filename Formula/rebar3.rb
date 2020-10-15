class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.14.1.tar.gz"
  sha256 "b01275b6cbdb354dcf9ed686fce2b5f9dfdd58972ded9e970e31b9215a8521f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4c1973e5ae4dac6fb7234772d7e0d385e4ae3154e2394ee66dd508586f2f1da0" => :catalina
    sha256 "24404cb0ce9c75b845756eea6deb48bfc2db488c217e423a0d19aa4befd05399" => :mojave
    sha256 "c43f7344f8f808d74246e05740d9f70f8c17565dbab0f10ce73ee02cbb1cd798" => :high_sierra
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
