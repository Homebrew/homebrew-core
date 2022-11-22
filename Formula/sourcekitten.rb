class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.33.1",
      revision: "fc12c0f182c5cf80781dd933b17a82eb98bd7c61"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "952b446c12d9f506fa18e519aa2c866c138c04f9b5fa0aa7bd95c4d0e73da56f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e0b80b6463bfa3b2a12647d1ae794f7014b82da3925a29f0a4f37b7a60dff05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7427e9fa38ae1c3d91bb9d2afd027f50b0fa2c814976260fbd60d45af2715a0a"
    sha256 cellar: :any_skip_relocation, ventura:        "c0aaf40b1323a46ba88c9e0f95be150e0a6b653b815d52d3ba84ab7e8e5f145d"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5ebd83b4dbea2fe1f1d704c88511adb7179ab13647f825c6957426e482cf7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3bcc001fec06724d61a75de962687e67af125a37c906404a026b499d3573087"
  end

  depends_on xcode: ["13.0", :build]
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
