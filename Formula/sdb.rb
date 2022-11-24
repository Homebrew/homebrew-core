class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radareorg/sdb"
  url "https://github.com/radareorg/sdb/archive/1.9.2.tar.gz"
  sha256 "58f45a1de7eace53d0bc1d7daf20c63102e1dda00198ca3799fe57dcfb1f06cc"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bebf2b31f8bd420872a49157e681331a095c2ed21f3be24ab0ce1e06aefaf4e5"
    sha256 cellar: :any,                 arm64_monterey: "77a1325cf44ed544e7cbb728aa9ca00d011866c2b76aa14e6d82670d20f4eae1"
    sha256 cellar: :any,                 arm64_big_sur:  "b2df40d1da24458b2ebe5618f2cef4d2c0c3ac62850b5cdf9af394b856f6c942"
    sha256 cellar: :any,                 ventura:        "73b2144282da3ebba7437ca54acafc525a1896e2d9e0e4789d91fd649fb95046"
    sha256 cellar: :any,                 monterey:       "c699238e0a5b460168187b8a620abde00fccf3250d57bf0c7698e47f437b57b1"
    sha256 cellar: :any,                 big_sur:        "be2ca6db7a7aad2bca2cd1adf5df27f480fd6cb8c429ece0e97b5939725eff89"
    sha256 cellar: :any,                 catalina:       "2804ccfd79accc3247685aaee3187f14331bc8a4b02a911a13c84fdae8550e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4b90d38a6a06bbfb716fcb12d2c0b605b0558abb9dd3c2566f4d2973ea180f"
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
