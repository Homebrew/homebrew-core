class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.32.0",
      revision: "817dfa6f2e09b0476f3a6c9dbc035991f02f0241"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc5c0a2647f3166425adeeba110c59d1585a06265f4a38a237110c3555ef0c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e286e85a138ce17306a41cd4685c33a1bdfdd8108f3a42b34975b30a2746cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "5bf5604b6d2db07359075d874960a2fc7d28c0fa365c015b1cc6a7cf4def133e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd867aad2393c0817d7e34f33d6873c540d1bef3fe0223dd2106c7412f10a818"
    sha256 cellar: :any_skip_relocation, catalina:       "32a08155e2e970e2c56dfe6007d1937366aac7e53f42dbbca2dbba5a5b799506"
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "version"
    return if MacOS::Xcode.version < 13

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
