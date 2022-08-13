class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.15.tar.gz"
  sha256 "716bd16fc1a1472ef2993e2ffbcc69b480dbebe7e305f049923b97f6acd7824c"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f8d9c244ced7e092cb18af0a36e1b64414e28dfbbc18beabe25fe0080aa3bca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1c062ceb1c7d933edb1e94f0cb1cb1b79b33821d565d26ebfbdf805def3b8f9"
    sha256 cellar: :any_skip_relocation, monterey:       "a3242f98aee8736737fac5091c35ed34532c6e9a7ec66532e9418731b12ce158"
    sha256 cellar: :any_skip_relocation, big_sur:        "76d9cd1efe09137f656c94c6498b80c2d9d7ca1f9cbd5a98d0699aa15629bd52"
    sha256 cellar: :any_skip_relocation, catalina:       "ac73b68d0225d794f415d5aedf0e2ffdbd1251e68e874a95f43c43431eeac518"
    sha256                               x86_64_linux:   "89ba5a1898f9e5ce08582cd56399d18713c4091cb2b56a91ef839420dae49096"
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
