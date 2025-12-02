class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "https://zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.5/zeromq-4.3.5.tar.gz"
  sha256 "6653ef5910f17954861fe72332e68b03ca6e4d9c7160eb3a8de5a5a913bfab43"
  license "MPL-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76e3d40941eb6d5d2ea5f94c017fd3503b68aee2aefc017291ab38b729fbcf08"
    sha256 cellar: :any,                 arm64_sequoia: "03990812828803732fe5253d9940e1a769012068f9af165804d2dd30255aa3c4"
    sha256 cellar: :any,                 arm64_sonoma:  "b8cce7aefa5cfeb55f94c81b7f707f1f7f7f7c24da3d91a4dab65fbf6a58cfcf"
    sha256 cellar: :any,                 arm64_ventura: "c02ef7aff4dbf4bb16896ef097ff8aad9ed7fefbb6daf84f7ae244d4e0f5b1ce"
    sha256 cellar: :any,                 sonoma:        "d605668191163ba70b7298653eab755dc07cf378244f0795c432cff918069008"
    sha256 cellar: :any,                 ventura:       "486b7daf69d76ef858c14fb822ee84d870d6f0c2a012eeaf13690915ce0e370b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1839d81ada31e9622a60dbd0617c9d12709ad290d3b3d2c7d83690e6da756802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f98a86b96ff8acd27fe0d06f651f376a392a5aa25fd61e084cd26718e241df30"
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
