class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.6.4.tar.gz"
  sha256 "577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07"
  license "Apache-2.0"
  head "https://github.com/rebar/rebar.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "425daa41363cc4872160fa64a3593188d0d564a6dac7d6f2ad45c1dc64db733c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92373b3f954401cb022c08aa56b7e29c8f15cee4a370978c7486c16c2b91ebdd"
    sha256 cellar: :any_skip_relocation, monterey:       "d3227a8ef5da18f8e70914c0661db9c1c500a6709edcbde979117438841874e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "17b587b45197068cb021a40a4b8a82c69aac233a5f259986d7ad6bc8c41244b8"
    sha256 cellar: :any_skip_relocation, catalina:       "1dca4b3d2760f3806569c7a455beb73508409177fd9a6f22816653f14e80fdee"
    sha256 cellar: :any_skip_relocation, mojave:         "265cfa8851de8a55ff46346167f8670df48d8a731c427d51fe0da16cf2ee8b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "521320b0d04fb8f9110d7941676344932cc88db4f5c757a3598bf7504d6bda5e"
  end

  # Deprecated upstream on 2016-04-13 in favor of rebar3:
  # https://github.com/erlang/rebar3
  deprecate! date: "2019-03-22", because: :repo_archived

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar"

    bash_completion.install "priv/shell-completion/bash/rebar"
    zsh_completion.install "priv/shell-completion/zsh/_rebar" => "_rebar"
    fish_completion.install "priv/shell-completion/fish/rebar.fish"
  end

  test do
    system bin/"rebar", "--version"
  end
end
