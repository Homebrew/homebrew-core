class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.61.0.tar.gz"
  sha256 "53523ffec0029bb9767a7fd899932ded99fa9c83ce46565d06a4a1f671460669"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7dd39c982e4a98505c446cb8b8ed26a2d7c292c969f699ba5fc0c800f1263d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f181882b440eb6f4a162a328f1c5cb010ce0437a6e48c48f5be7b67311446346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad4a7e36507d62b4503b6ff7a9817939a5f08b1a954bf39a4cd4e06fcf77476c"
    sha256 cellar: :any_skip_relocation, sonoma:        "76bfeff6654a5fc683a874900f7a7a2bcabd275f808de8faf254d018dc7c6db7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7a012938202f118145598b15d12599b45e4da00c560950460a97807a707680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d1b4c0f4c811f028a5e703911eecc8b4cbe06cbd9650693d773ace3706265c"
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
