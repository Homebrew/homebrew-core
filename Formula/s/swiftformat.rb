class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.53.8.tar.gz"
  sha256 "2ab95ae0d6faab14a15cd22098f28a05584f8fe18b21cfa8b523a8bd974e94e7"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ddef3d4ed968ab4b125f2afc912fa98d230c82f1887508617d004c830de7ba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd1c63ed5e620ef6d183e989988c082c0b8e86ee2f3f4e171496a4945371859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9a134644f14a2c0876722dc94a68c494b5d0c0dbf194a4ccf89c45d1dad2134"
    sha256 cellar: :any_skip_relocation, sonoma:         "8afd7ce153fdd12702933ff900f8d77e5a44984f4db871968ef68ed94a23524f"
    sha256 cellar: :any_skip_relocation, ventura:        "eab0600963983c83b7eaada1572f7ff7520a501de627da32655ccdd6f4fa4827"
    sha256 cellar: :any_skip_relocation, monterey:       "fbbd4736efe82680d21f5cc0778c7755d9718d96340b26287ae7e274f46fcde2"
    sha256                               x86_64_linux:   "9ed455d558a4ff04259d556f748b35fb28b155897024244b89a524648aee8bd0"
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
