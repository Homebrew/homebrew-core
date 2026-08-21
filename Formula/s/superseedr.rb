class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.13.tar.gz"
  sha256 "16435d8c1558315ff386af8cd5ea159123369fe6d69d21f3a4a1d2d6969af555"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96a657f9671739e7d3faee550fa09f91ce709970c22ab4db6232187bad20658d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b507134032a17996d5c2f2d1e7dae27cb987e385b6051efb3a9f05836e39d963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c16859652ba0752a2a9b8bbb7b14c9facc0214b8423c0d437e64d8517ac3a40"
    sha256 cellar: :any_skip_relocation, sonoma:        "98dd6dab5689986cccf0f680ffecdecd58c031dc4f1795ebedf479208bbab19a"
    sha256 cellar: :any,                 arm64_linux:   "b4a9025850e8c4434ff9117747c593911c86061b7112f262406278d8976732dd"
    sha256 cellar: :any,                 x86_64_linux:  "d9d93219c9f714eff155936be24717c7b748a60f040a42cb8983c707f40dc784"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
