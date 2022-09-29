class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.0.tar.gz"
  sha256 "234a3719cdd354ce158325c2091079a80f3415b60cc72cec742fb51ba085d75a"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6362f6087bc3821f4271c3d17b3a4f180b1e1326646ddfb60f6d27bfb5a2a357"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e94cf1b66df0d712bbfbf509b98efaf31d39a61b82999314e1f3c0e45195c51a"
    sha256 cellar: :any_skip_relocation, monterey:       "456e0c95a565adbb45a29747abfadf41c838a7f09fae052a874e59429a94ef14"
    sha256 cellar: :any_skip_relocation, big_sur:        "d00204be714789fa8b35d4c6f6eea5813604aa09f3911635059973aa827d2e8c"
    sha256 cellar: :any_skip_relocation, catalina:       "b07f7221f3c5225ad0037293cecb95bde4f0dba4fa19797d84a3376dd1ad02ea"
    sha256                               x86_64_linux:   "c4a4ebd2f3f54b8f399551efaf47b3e419db2c729ffaf18a09e64bbf62d82f38"
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
