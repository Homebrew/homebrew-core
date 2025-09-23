class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.58.0.tar.gz"
  sha256 "c4a147dd4bb192dc69a0591d8dc712ab408001f64bc5c81599218cb69d06f5da"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ce0cf9f4fac7ec9d09bfa464ea2f2889078f0f8aaba88d4513b581261eb319b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce4bb3f59b7e0cab2e5c06da17d3cad041f61a0d7fb4eb41a4ea07fd76098e74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdc4088cff35ba8f429faa54a069d4983f48036d6a82e10d5a390cb2284c96ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b70835c933b5708cea23e11d17a4223c6b71b3f227763ed91d2898fd0af80db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5795a72948dcaa836be0502ea84036fb8e81047fe052d2f16a7e130b340644e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07099999014968de369326e19b91b76b9b0e3a94f95d503f54dc1be453b8308f"
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
