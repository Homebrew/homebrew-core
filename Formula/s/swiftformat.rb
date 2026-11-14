class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.7.tar.gz"
  sha256 "1ab244207e2d15dbfbe61646be26513fa9060799792fb44ce0a180845fc8d971"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ed6116b46cd2b08a7f05277d2ae4fa5e6032840471251a48214c0f3ac2b4479"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99c82bc462391682d55db112e03356ef2bab944b1500b2e3718b1b65c16b50c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26de6076cc1f4db2b2ff021ed3619e768e73e34ba2712d57febb05a8e4664930"
    sha256 cellar: :any,                 arm64_linux:       "7d138c6b471b77712abbf1882596a42c3ccc506451a5fd64e7ef744087593fac"
    sha256 cellar: :any,                 x86_64_linux:      "66c595f1d104c42252c451bb5978f7792354adc2c92dfd51f1833637423cf5a6"
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
