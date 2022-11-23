class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-1.0.0.tar.gz"
  sha256 "d607fb816d71d97badce6301dd56e2538ef2badb6530c0a564b1092788f8f774"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5b1dd6314393471c6d94f5cd9417add5c2fb18cae43a8aadb55bc27782ff521"
    sha256 cellar: :any,                 arm64_monterey: "17187c82468ffb126744c6ac8f4bc318a11234923dd70759ed0b2204d949516f"
    sha256 cellar: :any,                 arm64_big_sur:  "1b2b1cc05fd4af9994aa34e57bc8767bdb567455e27458e1a9ac38e340603c68"
    sha256 cellar: :any,                 ventura:        "9f5be963c7067cdad5e22789cde8ca2eb21e9d587b538e57c228ab9b9bc90e1e"
    sha256 cellar: :any,                 monterey:       "8df24a5323536f451f373746c1a1643ce31967502c3d8cb99807ffca49e53413"
    sha256 cellar: :any,                 big_sur:        "6f469c28584124f46a7fa9835dee3311ef02d5a48f2d8fb8c8eb29f2c6688986"
    sha256 cellar: :any,                 catalina:       "b7e64101995d257df010edb67bafcd60745f09c7b0ebb9650c817eb7343f1899"
    sha256 cellar: :any,                 mojave:         "438c323c343b7aade2da46316d24bcc4d5c7a95910a43914d70125af14a17636"
    sha256 cellar: :any,                 high_sierra:    "4acbb473ce3be942b808af45789ccb7ede8199c728f7c381cd0dda1a105c8a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9dcde71d3afafa413ad52116f880796bd49f1a715159a794275fb4bd366de1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    mv bin/"bench", bin/"sparkey_bench"
  end

  test do
    system "#{bin}/sparkey", "createlog", "-c", "snappy", "test.spl"
    system "echo foo.bar | #{bin}/sparkey appendlog -d . test.spl"
    system "#{bin}/sparkey", "writehash", "test.spl"
    system "#{bin}/sparkey get test.spi foo | grep ^bar$"
  end
end
