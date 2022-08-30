class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.18.tar.gz"
  sha256 "a6abc684e1197c96d46a5e6138cee36c6101bd0b19467a476f9abb0d1032a298"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7f2dbc6e2d69c55e556339fd37bcb9b5085ffb26e18ece57f6614f68f71d9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6762a1f50c474ace807cbe505c40ec83e07d95f3a709b862b55a4aee358bcbc2"
    sha256 cellar: :any_skip_relocation, monterey:       "46ab8382cc299980caf2aa48ca4e08cf3b3052432959e2bd02ca190f168f563b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0145b1f25c402c6d3f4b022a1ec3fc1469b3d61428bc9f47405e2124cffda100"
    sha256 cellar: :any_skip_relocation, catalina:       "bc210385a7a34bd8babd475927d698e38feb6d9b6bc267f159acd67e90542380"
    sha256                               x86_64_linux:   "326c9a8cedeeb429315d94638a5c03a764194b346a2781fe858d5cb83d93662d"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
