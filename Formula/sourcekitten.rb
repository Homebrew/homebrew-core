class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.31.1",
      revision: "558628392eb31d37cb251cfe626c53eafd330df6"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc5c0a2647f3166425adeeba110c59d1585a06265f4a38a237110c3555ef0c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e286e85a138ce17306a41cd4685c33a1bdfdd8108f3a42b34975b30a2746cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "5bf5604b6d2db07359075d874960a2fc7d28c0fa365c015b1cc6a7cf4def133e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd867aad2393c0817d7e34f33d6873c540d1bef3fe0223dd2106c7412f10a818"
    sha256 cellar: :any_skip_relocation, catalina:       "32a08155e2e970e2c56dfe6007d1937366aac7e53f42dbbca2dbba5a5b799506"
  end

  depends_on xcode: ["11.4", :build]
  depends_on :macos
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end
