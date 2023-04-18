class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.23.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.23.tar.lz"
  sha256 "3cefb4f889da25094f593b43a91fd3aaba33a02053a51fb092e9b5e8adb660a3"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c7f680ff8a870429c7a98f8bb0edf8b850bfbc0c626b37310b21dca9fb4dc6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fcc9cf154b30fea24d72a427df605d4b72ee416f1e84f11ea57a058e0cb37ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b06bcb32d18976af959d11e388647c81d6374aee847bff9b8449176e87fd5bb"
    sha256 cellar: :any_skip_relocation, ventura:        "66c15f18d1a4bf05abde08bcc1e28622c97ee2be33457c28b6a57c8af53416c1"
    sha256 cellar: :any_skip_relocation, monterey:       "465b6e8af9bb245935f364856954d6970f4f5f853d1c7d76d65e9e5fcc98285a"
    sha256 cellar: :any_skip_relocation, big_sur:        "994f2a00cfed90ac4892b1e134d176db4a6cdaea9ceea3b6118988a19ba7d9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caabaeecb23126c911dc1d0cb8e3c677b92818450ee4f3388dfaa558b354a864"
  end

  depends_on "lzlib"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    spath = testpath/"source"
    dpath = testpath/"destination"
    stestfilepath = spath/"test.txt"
    dtestfilepath = dpath/"source/test.txt"
    lzipfilepath = testpath/"test.tar.lz"
    stestfilepath.write "TEST CONTENT"

    mkdir_p spath
    mkdir_p dpath

    system "#{bin}/tarlz", "-C", testpath, "-cf", lzipfilepath, "source"
    assert_predicate lzipfilepath, :exist?

    system "#{bin}/tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end
