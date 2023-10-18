class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "https://zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.5/zeromq-4.3.5.tar.gz"
  sha256 "6653ef5910f17954861fe72332e68b03ca6e4d9c7160eb3a8de5a5a913bfab43"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a9cbfb80e43d28c3a8871b7d5ffd7d9b4063e3ae331e7ef386d16f1a6189936"
    sha256 cellar: :any,                 arm64_ventura:  "4bf90a33c91ed8cb4ffadbb6659688da9900df3568d6e2ef39f80cc2a74f7b35"
    sha256 cellar: :any,                 arm64_monterey: "7bf8e1dc5c4412df84c158090ecbf6663e00a6dc5da6b7e71f5f9c991484c47b"
    sha256 cellar: :any,                 sonoma:         "9b85bd11720da06156daf3671a419c1fcb37e63086417f5b4de86b7830baf653"
    sha256 cellar: :any,                 ventura:        "aea0c66541f97bd22a81c8908efc97d5b555653e4bbbdd177a186c570cf221ac"
    sha256 cellar: :any,                 monterey:       "04e39c5b511bfdef7c383638076ff1009acd5a9cfc7cded4bb76cc5045928a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ae381d326c253fa3e2aa672002577dc744cace025545841c829718012ab6d5"
  end

  head do
    url "https://github.com/zeromq/libzmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "xmlto" => :build

  depends_on "libsodium"

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable libunwind support due to pkg-config problem
    # https://github.com/Homebrew/homebrew-core/pull/35940#issuecomment-454177261

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-libsodium"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
    system "pkg-config", "libzmq", "--cflags"
    system "pkg-config", "libzmq", "--libs"
  end
end
