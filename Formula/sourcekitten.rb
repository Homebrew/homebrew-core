class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.32.0",
      revision: "817dfa6f2e09b0476f3a6c9dbc035991f02f0241"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18e81d5d3bdb1c4e27ef3a53f5c6cecee6480a6b7aa4200f7867ad3ea388af2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c496e5c003aa4ecd13df4cbc5dcf2e228ecf41b7c22b640fb855b909fd02a9d5"
    sha256 cellar: :any_skip_relocation, monterey:       "7f95c48e5b08c175175e0e103ef06deb3ce503d7db25f48306c7b9856a08bc51"
    sha256 cellar: :any_skip_relocation, big_sur:        "664a587564d6386c4bef31b5e862f51499a2f70d6c79997a2657b5dc47266bc6"
    sha256 cellar: :any_skip_relocation, catalina:       "77e05bd04bb3701b01740f1e74725776a9df6f0d2be370db7d5bd450665dd2a1"
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
