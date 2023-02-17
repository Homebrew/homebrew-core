class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.9.tar.gz"
  sha256 "301c20fe2da311553782aa5ccb3fdcb9fdcc39be956e83890464dbdc61c8d461"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cad1a6616dc8cf34f878fac3344b9328b12d2f6f0de4ee9ed60caff00fed86ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ea6096ee466c467ab151e6109a0e22bdb1ed880e2e70a2c8575edd0ae76884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3982c52cdc2f95ea06a344da46896b9a6919fdc1cc6f4a55021ec90195040ab"
    sha256 cellar: :any_skip_relocation, ventura:        "7e064ffd008157e422424516320e261c5c980ac23ccc7d60490351d4f126add7"
    sha256 cellar: :any_skip_relocation, monterey:       "82a02c62646dbad9afdd49c2e22803e76c94686e69f7d2a4d21c110ce87db097"
    sha256 cellar: :any_skip_relocation, big_sur:        "cafbd55ce5c722b1e8fa8e0d6ec4f2f9ccf4a16171bc2cbec9dff5528d1b399d"
    sha256                               x86_64_linux:   "07eceb640a1bc45dec651afecf932c7bfbabfac24d9a59e322cf89c8a48a01fd"
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
