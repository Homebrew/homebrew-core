class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.5.tar.gz"
  sha256 "5b0e222311e0217a14cc4ea6da9870f5ed087345d88e3bac7818fa584f66aa02"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53f6e5214441b614db425d1ac357c657e7443264a4a74742010b450b24fdbe60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43fc053c7756222f020834f8576147e9e7a169b200fda6932e136edb7ffc1fec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dea73c07942d96b474df70aad68a67bed77e2198b6f4d09bf4104365a5a8c3e9"
    sha256 cellar: :any_skip_relocation, ventura:        "a25962ccec3ff4bc87373abdcee748e3a6a444322a86e44f310c1741c3188084"
    sha256 cellar: :any_skip_relocation, monterey:       "15328aa92a92188a04a1d2ef9336d35516157152ac3a5a70aa4ecd88d9354fca"
    sha256 cellar: :any_skip_relocation, big_sur:        "1881593eb078d6af8ca3add44e39fe0a3df2fc3fcd35a4edbe4731b42650c73a"
    sha256 cellar: :any_skip_relocation, catalina:       "c2f385eb894035279f3ba687454a75f08da0cd357a27b5175be8914d4fe69a49"
    sha256                               x86_64_linux:   "afde911f5ec389217feb72ca5795b418a9e10050aff9559e0f61f89287463786"
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
