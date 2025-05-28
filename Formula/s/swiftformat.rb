class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.56.2.tar.gz"
  sha256 "fa1d8bbfef7d93c9cf4d5b25b098ceaec85a9631d5b1abbd8c889881c6b11940"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "798587554c53ee1f9d5d05e725eb0bd218c60ec720120e8d11db2334904e8fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e995609eeb3a0d151cf0029d858dfe33ee9988f564d3c10d808b6ec0e04acff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e3d4e4efda16467029e9b14c74e50ab6c81476f2280675c80659f1130fd09b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f0567bab8a3a0bb098f5cfb23494849812c427abac5cb8314bb5c31139a4986"
    sha256 cellar: :any_skip_relocation, ventura:       "2e12abffdfdf2136260ea983f8fb307f3b7554d5e2ffd6e118ac4c817fce9a25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "775431f48ea875a7a9b3aeca60344d7a7ce3e2e614f108cf05048d7d4e9ab9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56d3418841243f8e1c675e68dff6d1011ece3efc0ed3f3390931a4ae3e3539d"
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
