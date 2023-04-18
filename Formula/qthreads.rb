class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://github.com/Qthreads/qthreads"
  url "https://github.com/Qthreads/qthreads/archive/refs/tags/1.18.tar.gz"
  sha256 "c2d1ba85533dc980ff61e422c9b7531417e8884c3a1a701d59229c0e6956594c"
  license "BSD-3-Clause"
  head "https://github.com/Qthreads/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5d9d7bd839e5ea29c6e9907907d153388c37f6011242c241ca650f19a6b75e73"
    sha256 cellar: :any,                 arm64_monterey: "20e1c3bfd839efc644db0d69c98d0d58a9fce71b4a2830d054d4792d5180fc92"
    sha256 cellar: :any,                 arm64_big_sur:  "a584249b31c678d1a723e3c2dc78ce455a76275baef8e9d3c59e5d624f0f5369"
    sha256 cellar: :any,                 ventura:        "847863371988e92cc7e6d1290db352f9dcdf7847c5baeca4fe18bf02d403be57"
    sha256 cellar: :any,                 monterey:       "b60ec614ce7bd7cfc835a084e1aa371efa7bbf3790f84f8942e5933f4b77fd27"
    sha256 cellar: :any,                 big_sur:        "0523493be01de6b4e4159ac430693ce59919d3970349643b8b9278bbe1fe6054"
    sha256 cellar: :any,                 catalina:       "c4f9b57d8bd7fb1536aa668317d3fc5cff24ca3db5d78a8d52f26f80431277fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083a3510caf257af5108d87e1d23cc036c5e65e3263487d68ee1afb41d6fa6bf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
    pkgshare.install "userguide/examples"
    doc.install "userguide"
  end

  test do
    system ENV.cc, pkgshare/"examples/hello_world.c", "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread"
    assert_equal "Hello, world!", shell_output("./hello").chomp
  end
end
