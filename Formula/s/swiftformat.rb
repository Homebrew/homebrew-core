class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.61.1.tar.gz"
  sha256 "c889e21e823313f67bfb4f364afaffc0141e3143fdea44e90d752a3d5cedc9c8"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f9ee68bb4d447ebf6e3c7816dc67577a5cee498614a55064add2224e278ed52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "078438fe8be63c0dcb3a02cf4a0abbfa45c1b8218be3f4097e8d44857147979d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2beb2997ce08de9e04a4cebc8363d2fc94eac1b34bf023b547f2747d056e3ca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fbaf5f42c75735beafad0dbed2370d58eedc679b4cc1165f64b9d5cfb9f8257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc3672c5a1460afcccaa6f66c3b160846da93edd945a2816fec55dd83cf1f1c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e834c12c65ffeb4d2a049ab17a761277ea0f23ae2389d68cff5501e4a9b26ee"
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
