class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.63.0.tar.gz"
  sha256 "9a5fc7a8716d7501b3816877e54427f179876de4a7512681f5d9fadc0f70030a"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d304e884282a46778b196290bc550f8466c4e0a826092217df42ea675b8c6706"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7988e8fae324d4ff237c4979e5c9e673abb7c6bf0acc841263bd690a0931830f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4bf927e2e38f399b1629d831fb4d4f04f24a34ea17eef26cb698d698495cf4a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2cd6359a6e22d8db6a501e0d833f7641b655107e080972e24dfce0b648c6ef21"
    sha256 cellar: :any,                 arm64_linux:       "330d3b61f6de80cf4fb297bbd2d2eef1f8beb311e50799ee067c36ecac99e994"
    sha256 cellar: :any,                 x86_64_linux:      "12eeb23b53b221b915ab9abe56e988db2dc141d0c87ca3bb5d0f00f1342bde45"
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
