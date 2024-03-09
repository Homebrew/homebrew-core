class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.53.4.tar.gz"
  sha256 "b0240c8bb006d63ce7263afa7c3c4797a20fbd58f64df8f5109ffb293c5f7b70"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97458313969207e9c5bd456f826573350ab3b9ca2fdaa53561cb8a07e31b354f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77ac50bf35361686eb90a857fbe24ae8b90d30fea9631b155418c70835c7f550"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c4fffad70c3844ca7551629fb0b4bef694d4ba3ae861895d9ea67b7602bb30"
    sha256 cellar: :any_skip_relocation, sonoma:         "1766d47e2caa79a65aa2bb2d7bf4981a6ce8413d4f4b99e798b2cac930d2917d"
    sha256 cellar: :any_skip_relocation, ventura:        "32596ab299daf61a756c09d055bc4bdc5d63b190787c1432fdbffa8236a2e964"
    sha256 cellar: :any_skip_relocation, monterey:       "445e31123eddec655474956d1b3a3f81676ecf1d63a227fe891016b673e4c3dc"
    sha256                               x86_64_linux:   "15bb574d7afea06b1cefee619fb33c7dd135c3c85bce2c02fc4ee6989f578501"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
