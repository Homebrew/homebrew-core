class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.35.0",
      revision: "fd4df99170f5e9d7cf9aa8312aa8506e0e7a44e7"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bd1035c22cd6761912daa069a6f20f49b312d7aa2cc217a8004796f37ee080f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eafdd15b9e0de09d67b815c6daf250d61976f4baf11513c558a430b0bb5182fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e35a2af7a4273b844ab35b150e8e6a45553c3078fdfe2c5d15bd38a68ec1156"
    sha256 cellar: :any_skip_relocation, sonoma:         "8779a196675cad2cddec33812545647731994a36cf9542de513bfa9e0ed85093"
    sha256 cellar: :any_skip_relocation, ventura:        "44cfbed75b6096db3306b208d008ef619604c72587ab3ee4ead87e82f7681b32"
    sha256 cellar: :any_skip_relocation, monterey:       "b97ff5ab90b33c889a57fe2a5b80117cc4e7649e790658cfb55611bebbc54885"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system "#{bin}/sourcekitten", "version"
    return if OS.mac? && MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system "#{bin}/sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
