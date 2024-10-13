class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.7.0.tar.bz2"
  sha256 "8944b237968a1b3976a1eb47cd556916e041a2aa8917495db65f82c3fcc2a225"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "34fa8bce44dec654eccbaf58d97fe7e9ae4824f5aaaf3ed3ac8ea8acf5e04f86"
    sha256 cellar: :any,                 arm64_sonoma:   "a52595d292c101c9976c2ef02756e0d90b985a10e58a7305d9a4a31279eecf57"
    sha256 cellar: :any,                 arm64_ventura:  "18dc138bdded56a9eeb9b246b5a1c2b809ab27be62b55fbd19f3a04f96517dc5"
    sha256 cellar: :any,                 arm64_monterey: "d920574d1f4493faf11e8d772ed39821159349c22c6de11be99f8058bfbea686"
    sha256 cellar: :any,                 sonoma:         "8595bdb5181479ab687368280cf55758afde4017d67a15b93923a6dff487734c"
    sha256 cellar: :any,                 ventura:        "139b76fb2ed0c471294576ea6ba387fbed526c3c228bee05a2bfced748f6788f"
    sha256 cellar: :any,                 monterey:       "e0d0a48bca189c2a28edd80c406f3c09693d1f6d351ff21b6bf74b7210bc72e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9564559131803d0e34f4d72c42ea6d20046197ea49b5fc58250cba812cfb66"
  end

  head do
    url "https://github.com/dbry/WavPack.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    # ARM assembly not currently supported
    # https://github.com/dbry/WavPack/issues/93
    args << "--disable-asm" if Hardware::CPU.arm?

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    assert_predicate testpath/"test.wv", :exist?
  end
end
