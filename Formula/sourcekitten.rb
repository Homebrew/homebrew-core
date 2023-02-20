class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.34.1",
      revision: "b6dc09ee51dfb0c66e042d2328c017483a1a5d56"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09d3be8ac7d2f603f9ce3d2dca86f65304887c3df8f9dded6d8595cdd4120ad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf73427cc343731ff60b706692e5f421c80a2b978e8b084b40569e2a88f6589"
    sha256 cellar: :any_skip_relocation, ventura:        "b4e5bfb6ba1fe095adf84cbcbd7624c92ba4c3d71bb9e0b686a00995b4b39913"
    sha256 cellar: :any_skip_relocation, monterey:       "27462a53d6bb914b4483744c7dab1e3cb7deb4db396f9753ff6be174299f99a8"
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
