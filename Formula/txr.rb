class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-287.tar.bz2"
  sha256 "2f4f87d4d0dd1242b33b85e3eae3eed3e0889db17e27c7b5b5adab0b6b830f53"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89bc69bd36aa5b977f539a2d39699fd9b962cb1183f0b6c61e05af6f46731ccc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9c1288de80adcc0d507179159a3a8a5d6eaef08c1bf23657b469731e5c5a147"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15a1d16c168b6102d9e187e7f50f4acd8e4d37f2ba5b5a49c18c26cdbe0497e5"
    sha256 cellar: :any_skip_relocation, ventura:        "503bb5adb1fd7485d396eff2c0787da2804f579903d476760a7633bfb2e31091"
    sha256 cellar: :any_skip_relocation, monterey:       "d5ef748d00212d096fe10df33c8e2a7ca993b4c35e9597bd225a69b6d5dedc20"
    sha256 cellar: :any_skip_relocation, big_sur:        "24396d1583278c5ea089eb5dd6a917d2e525a1eb85fa5d0d604807cfb9ea1859"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end
