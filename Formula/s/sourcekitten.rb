class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.37.2",
      revision: "731ffe6a35344a19bab00cdca1c952d5b4fee4d8"
  license "MIT"
  revision 1
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a7b279f3603cae2b43cfc554cfe772cc6a1abda9e6c58bedf624e44981ff789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2796fe674c035f08a61ff4794a3d5aa2c2572384f31afe4360e24cc6c8c606fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02deae6e801c0334b8b7e919a22b53887dfa52c4a2c46fc1b5c5488d3c537a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96d22c0dd1561f4739a4ae689d0e6f17144901986525ae2aa047900db9cee26"
    sha256                               arm64_linux:   "67774c0efaa24dbbf3167ff1b2c44e5d08169e67aee37b85c7034528d55d68c0"
    sha256                               x86_64_linux:  "55c8b56cd5c2ca875f3d2cc4498fed128fae7b0ee0e5305ae02e390b2ed89814"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "6.0"

  uses_from_macos "swift"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
    generate_completions_from_executable(bin/"sourcekitten", "--generate-completion-script")
  end

  test do
    system bin/"sourcekitten", "version"
    return if OS.mac? && MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system bin/"sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
