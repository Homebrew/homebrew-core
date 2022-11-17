class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/2.2.0.tar.gz"
  sha256 "6a0a19ca5e73b2bef9481c29a508d2413ca1a0a9a5a6b1bd9bbd695a7626cbf9"
  license "Apache-2.0"
  head "https://github.com/ggreer/the_silver_searcher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "817b92ceac05e4860cdd5f7102289f55494359bb67c9fe4c8213d87b53261d7c"
    sha256 cellar: :any,                 arm64_monterey: "b567416368a9b131cf32f2c81400327a059da194c6d95df7368aa039fac73dfb"
    sha256 cellar: :any,                 arm64_big_sur:  "a1fa06a9147b1138f884408f88557357e4a48330373f720ca428aac0f3333221"
    sha256 cellar: :any,                 ventura:        "75b86330b34c4d6326b44c3f22f3b8e7fb912889e0a3765e5ef805b0127764b3"
    sha256 cellar: :any,                 monterey:       "613ce2a96feead807bb675c2a72388fdfde47b1f7702031909fc558dc0faf11f"
    sha256 cellar: :any,                 big_sur:        "e0fe6360a649e3a9722d72d258a65a4ec449e76e82166c9d0fc48530e73e952e"
    sha256 cellar: :any,                 catalina:       "6fd80fdd0896dae09c01d3c9785ddd658bb5f2f229e7d011d3fbdde887bc35d0"
    sha256 cellar: :any,                 mojave:         "e57f89664f48c131dfb462dc4be2f5265867d827f82efb1c3841ba71d9156ed0"
    sha256 cellar: :any,                 high_sierra:    "0bf5394d8ab5f61b8fbb593249f556f13b358d16eb0d3c97215be3da0476e94b"
    sha256 cellar: :any,                 sierra:         "2365e24e5d0b1bef64b35c6a8f9e4f61d1f38eafe38c06d6e0acefc6a9a955db"
    sha256 cellar: :any,                 el_capitan:     "1f35dcee133d638a16462db711560b624020e9dd8f732ac5a6f13a09b694421a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b2980ce1d36b89a1620934e9d513116bf2707396027d54a0096a088656228f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz"

  def install
    # Stable tarball does not include pre-generated configure script
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
