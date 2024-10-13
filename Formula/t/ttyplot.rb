class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.7.0.tar.gz"
  sha256 "f16ca828bf73f56c05ed4e1797a23861aa7cf3a98fe3fcc8c992d8646906fe51"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d5e688a5a6c20b778cded7c5ea4d0448031c9a0b8043e911eca4efaacd9de0fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9ecefa3d988d46df9aee5f0b7f23a6872aed01e1c87d41ba98998fdac25cc7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b21894bb2c2f3c8e01edd06ebb92a2b03a446abda878003d7f5dd1e2d9b2c85e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f4f169ae0a2e9c685d2c8a0417e479f98c142b122317d7f974738e7c864f555"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eea76d29ded7949c4ead591e38d43f09731c0d2eaeee1b96f5c8f881d31716d"
    sha256 cellar: :any_skip_relocation, ventura:        "352a9a56d39218ca1bac54a75b995bd65cd95b21482208d1a09a72f20482f7b6"
    sha256 cellar: :any_skip_relocation, monterey:       "1a5366ca6632a87f563031e050670ee154c7c1f8a14a459f4c53170a26217fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d5ff7c36ca059d6505a68598fd91ff6b2a8f48837cce27d829a3648cbbbad50"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}/ttyplot -h")
  end
end
