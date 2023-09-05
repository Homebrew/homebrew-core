class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.6.0.tar.bz2"
  sha256 "8cbfa15927d29bcf953db35c0cfca7424344ff43ebe4083daf161577fb839cc1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b5d5e7de0c7e1d77a4594c8d2ee9ea57253926261875279cec5d57fe3d7f561"
    sha256 cellar: :any,                 arm64_monterey: "7b6c68f56f22027dcd9b5355b5f0bb8036b97a24a767732cb921573ea5f0424b"
    sha256 cellar: :any,                 arm64_big_sur:  "31f0462f8aa49dea696e2c3fd2de063f683e6dea931cecce0f6ee85a6affe031"
    sha256 cellar: :any,                 ventura:        "1c2d9b68703a6da68805c808f96e318e7a760e31f25d47d723c1dd8dfbc268c3"
    sha256 cellar: :any,                 monterey:       "3c22e00ccb4c182fa6aef5a91d5a6f9914e657e00a567bb7709cd43d92598db2"
    sha256 cellar: :any,                 big_sur:        "919c8c02f44926effa043cedf4252dd79c475f07b51cc6a7f656e8f7debc41b3"
    sha256 cellar: :any,                 catalina:       "77d5572af643eaa5c4dfab561427887701af875b865bae2856ea361e5e67da58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5f47e688c698f7bad7d92733f4dde6444dedc958f8535ff7b290df7391b5f7"
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
