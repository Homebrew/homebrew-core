class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-300.tar.bz2"
  sha256 "05c63c509c5daa6fafc9e2321301f43751b249b3fac0827fca0e302323985528"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aed5d81c543b8a4cffb51dda400d11754e6754060c287c0106f7e911097c49e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ca9d8fac0a70b1bca8c227f95e0a044f5478dbeec2b39d45cdb8e4ae0a307c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f5223186feb95344f8817aad654b8707a0354efe1478470428d8da708d98f44"
    sha256 cellar: :any_skip_relocation, sonoma:        "7001f3bbbbbe457a9ff7f243aa14dd30fb5734a1cbb4403905807ec63c950876"
    sha256 cellar: :any_skip_relocation, ventura:       "17f1f5aa949003ac58959c99ea95068f04bd288ba57a911613748c9ec654bed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34623389b33a52a147599ce8e250632d12ca028046506d892ada2b870306e2a"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with :gcc do
    version "11"
    cause "Segmentation faults running TXR"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "tests" # run tests as upstream has gotten reports of broken TXR in Homebrew
    system "make", "install"
    (share/"vim/vimfiles/syntax").install Dir["*.vim"]
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end
