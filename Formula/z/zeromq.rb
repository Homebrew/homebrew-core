class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "https://zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.5/zeromq-4.3.5.tar.gz"
  sha256 "6653ef5910f17954861fe72332e68b03ca6e4d9c7160eb3a8de5a5a913bfab43"
  license "MPL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4314df24dbc51fc3a550abae4669d5daee4d0d5f7345efb1a293dcb00b0dc658"
    sha256 cellar: :any,                 arm64_sonoma:  "ad58b22edf3778517afe34abfe00228431091f78250584041ff8dea6cc272958"
    sha256 cellar: :any,                 arm64_ventura: "871565b7664a22baccbd3f305c36080f89a40fcb1475db9154387f356f2485dd"
    sha256 cellar: :any,                 sonoma:        "47a577cadb085e473b583c7d2eb13c10830c91ac96f03604867e7e841b89aeb5"
    sha256 cellar: :any,                 ventura:       "984be44555789dde7ec0bdb1e6d2ba85d89325bf9905f34d2f194d167e06114c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d636949e159c733480d4fdb333eabb95ba00bbf9d1477a4145eaae8ed379a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c660f6bb7620804f6143a739971b08a35a85bf60958151bac76bfdf8817b8ae7"
  end

  head do
    url "https://github.com/zeromq/libzmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "xmlto" => :build

  depends_on "libsodium"

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    if OS.mac? && MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable libunwind support due to pkg-config problem
    # https://github.com/Homebrew/homebrew-core/pull/35940#issuecomment-454177261

    system "./autogen.sh" if build.head?
    system "./configure", "--with-libsodium", "--enable-drafts", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
    system "pkg-config", "libzmq", "--cflags"
    system "pkg-config", "libzmq", "--libs"
  end
end
