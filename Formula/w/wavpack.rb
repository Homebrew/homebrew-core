class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.9.0.tar.bz2"
  sha256 "b0038f515d322042aaa6bd352d437729c6f5f904363cc85bbc9b0d8bd4a81927"
  license "BSD-3-Clause"

  # The first-party download page also links to `xmms-wavpack` releases, so
  # we have to avoid those versions.
  livecheck do
    url "https://www.wavpack.com/downloads.html"
    regex(%r{href=(?:["']/?|.*?/)wavpack[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5371e8c937d28291ca590221a137a8f1f049538a6352f89373831c2ad1f06485"
    sha256 cellar: :any,                 arm64_sequoia: "32423cac61dcc601979167b1be681f1713540ec321e3d215c70809af8a602075"
    sha256 cellar: :any,                 arm64_sonoma:  "219edda109ba98caeca085aabcdf600bf05926e11fb39d9ab9824f0af2a4d92a"
    sha256 cellar: :any,                 sonoma:        "69543fc68256b5bff54d6fb7353dabd5ba424af3cf88f3c3422f8cd7ca9468fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87a54977cdf0fe059aacf5944a758978d5f055d3bbbd777f6e972a3392744413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "912012e083e4a78f3ccb633cf0f5bad73826068a588d27e500be4ce907838b4a"
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
    assert_path_exists testpath/"test.wv"
  end
end
