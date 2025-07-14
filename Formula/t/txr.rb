class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-301.tar.bz2"
  sha256 "9f48abae83556f95080a3b2968048ee881acfb37e20f780ae8bc8b03e069a62c"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a1a05796b6d9e0ef0b21ffb123961121cb3a501f908fa27164624021fb8b0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31078d7be1e5b1163ffbdf5e9cf3e0aa12b07dabcd7e3e4772d7d2306902c3eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8665cdbb94720634c4d4e14094c98f4aa305b8622664a0c2feb8ef200129052d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c87559a2309dd9f39fbb21bcd73edb532444fe6aff893ecfc8c3d251f64c7ea"
    sha256 cellar: :any_skip_relocation, ventura:       "154e96e9d0ac11e7f034e1d7223f9f97ce70c70f7ac49407c1588592063031b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98198c32181375e0aa2d131e65b23eae96ae4f7e991166096c05aa61cd0ecdbb"
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
