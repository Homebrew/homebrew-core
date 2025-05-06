class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.55.6.tar.gz"
  sha256 "3914c84ccd1e03a7dd3a518f90b1987c4b7c5dcb7f81b86aad23a3fed53a7b0f"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7617fbec05965e628176ee52fd4f329801eaa31d58ef28d719df0e88ec2a75b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21d23eecd29ea88277dac99c69307891c5d211e2ce3d07c8837d288932323638"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4be36964f44ccec1ee52b49c5cfe193cf2663b6577f614ad06bc9d8304ecb5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2e47ab9381c868c3b26db4310e4444c8def05633cf4b151b2c914855601bb9a"
    sha256 cellar: :any_skip_relocation, ventura:       "09fcb8588558a4b6bc3ab0871b199b9a6f9cf0fc4678c2a281631e683b2f8e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dec312c72eaaa7efbe0a4e9ddf94f17376b5e6aad83cee683df24ada6eb0d95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff36605e03ca0da690a99ec69da3edcabc76b407fc41a56f0fbc0ef4888be130"
  end

  depends_on xcode: ["10.1", :build]

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
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end
