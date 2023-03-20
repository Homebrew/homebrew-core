class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.34.1",
      revision: "b6dc09ee51dfb0c66e042d2328c017483a1a5d56"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf824c9e874b8f19c74a0553ba0d7977cd151295f9920059a740768cb1b99913"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aba055153236af33d75a900140217f5bee6f939a291de46720ae73b5cc0583f"
    sha256 cellar: :any_skip_relocation, ventura:        "64087bd481a91558143401b526a698b33594a8b831898d7f15b23c8d0d0fb50c"
    sha256 cellar: :any_skip_relocation, monterey:       "760aeb628d7253077edca91193dc39cb18b54af8668ab520b28b0ee357ac2a01"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "version"
    return if MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
