class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.60.1.tar.gz"
  sha256 "efac3144a443791871bff9d065a8b7dd1f563fe79881df0164f47b387ae31f21"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "271a8fa4ac6749a9414ebf0dfddcc8d5795fcaeb9e7955345f7078a6e1dd18a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c31c7f04273098173ef720e066d694dd56be4b196eadeabec9bad5d0220ae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "964f5e100ed37eba6f024a0f5a604f878ec8ce6d3e8c41de6e645fdbda10b568"
    sha256 cellar: :any_skip_relocation, sonoma:        "f94e6f74b1571ef615733aa9c5dba34fcb1f5a5a00a3f0b760bc2831a7ca567b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "467590ea4278dc401a4121f9d5fd7d8a903f0efe754e707d24fdc9eec21c4690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae75602423adc874ebf84f90bb48d42069f6939077acb8d177e2bf9a84e85323"
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
