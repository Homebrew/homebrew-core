class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.6.tar.gz"
  sha256 "66f4074a8a13eadee622635e4c38aa82e9b84db43c92939881892cda19dd50da"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "342f164aede8d6b8dcc94298989aa805f819c4cd103d281e14728fc4ee9c435c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28cd333dec1590ee56f8d948d55d76f814141450bd1e5ce8080eab020084db68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae322f512d5fe7919862b46d83aea24fb489428ac27832e1e606a0aaf4528985"
    sha256 cellar: :any,                 arm64_linux:       "472c1d78e420df17704048fa3041f3f89788b3ee3698ebcbf84f18592337e7c4"
    sha256 cellar: :any,                 x86_64_linux:      "0ed1456906abf69fef89325cc4ed58081d7a1e3d3381319b90135a3c550638dd"
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
