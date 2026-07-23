class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.62.1.tar.gz"
  sha256 "cf078cc044b998aa4bafad731ae2d360242e820ba0acc4c6f2856b99e6052e12"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d66ed3272bd0aa65945b60f5a8ed670d70e73e4451ff66a517057f390d924a48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0970555d9ea51a4cf58034c54ae05da9ddb5ced370a0396c98a5c0acff327206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ccba932fdaabba24326973ad119fa56cfb83524c53e661c59aa150096a7d00b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b9e1cfdb402b73c3a2332aa035417b508ede21073ce934f4089a08509ea3e4c"
    sha256 cellar: :any,                 arm64_linux:   "582e0e2085b3e8f0d21457f5dddb260d73afec07dc4fe4d6a98fe1cf47e471ba"
    sha256 cellar: :any,                 x86_64_linux:  "10495777d080c3cde39c3af9d6971fd7bcacb9fa1d24b7641c31935be9e5302d"
  end

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
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
