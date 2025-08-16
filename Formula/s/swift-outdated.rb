class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.9.1.tar.gz"
  sha256 "0f03f6771603df17bf0d64ff73a8f026d48ee33d0084eb33b88b5405aee39071"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c854d719500ecd9228e4d10a0008da09ac89589a548a5bbc2d92aa2fc5c99281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a44bc14904726aa8cf2d4bc15cd3be7b59c7f00ef584cd9b79d7609910c71e09"
    sha256 cellar: :any,                 arm64_ventura: "d6fa404a960bc8522d91a45bfa9e2d52b7baab491c6c5e0229a13f5a1ece022b"
    sha256 cellar: :any_skip_relocation, sonoma:        "727817c88b6c5e964dfa2deb2b14b5028364000f4eee8dc8693a982cacc36cf3"
    sha256 cellar: :any,                 ventura:       "c996f9b83bc6d56580acdc89c83958a30d3ca23adae922d1c4eadfd408906164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "284ed8674d3a5dbe92d9d0c7068fad398ac559b6ac9696c48687f2eca6d00f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be519ea7c102f4277ca2d217c9eb2275f90c3431205809bc4f99c15620ea2763"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
