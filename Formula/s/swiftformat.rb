class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.6.tar.gz"
  sha256 "66f4074a8a13eadee622635e4c38aa82e9b84db43c92939881892cda19dd50da"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0309219e711e2d68fd0477fd7debe5df7410ba7239a04312c4a0c849800f052e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f5d72966f232c6a289afd79fe2ee14be1f70eda731579186b6ec9b00f4d3a97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3235b6940adc29b5f4112829f04f1611458d01b5a5082587cd4620b3d0a93921"
    sha256 cellar: :any,                 arm64_linux:       "b5137f19fd0d23abfc6cea112cd45c67ab446dfa8c48c588b706ddc6ed07d899"
    sha256 cellar: :any,                 x86_64_linux:      "82273c32e080970705cb2eb0c94b5a4a82513b43baebf3ce9cc983add01dfcb1"
  end

  uses_from_macos "swift" => :build

  deny_network_access!

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", testpath/"potato.swift"
  end
end
