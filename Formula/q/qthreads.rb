class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://www.sandia.gov/qthreads/"
  url "https://github.com/sandialabs/qthreads/archive/refs/tags/1.20.tar.gz"
  sha256 "b25ccd357575080103b2bec9358ea2f7f4ed7f60a29bf07fa46f96625bd635bd"
  license "BSD-3-Clause"
  head "https://github.com/sandialabs/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "545fad655e338500296289258178ffc562640214acaedf1b39ab4157e6c46409"
    sha256 cellar: :any,                 arm64_ventura:  "a97ca88a27f0b3f946190a5c1576835b9025514424826d9feafdabffb2a1775f"
    sha256 cellar: :any,                 arm64_monterey: "47ebb325aa47fa06c2d4e0aff9ba33d5bc6eed04f5dd5c83e547fb7faf7d73df"
    sha256 cellar: :any,                 sonoma:         "09f77cc7b4020f5d64fa9917e997a6ebbe8e6ad7bdc89dee6462ad23c6470220"
    sha256 cellar: :any,                 ventura:        "eecdd4f6ea3dec73452873f4b052c819722619dcb58782e93a1b424f40a16d9b"
    sha256 cellar: :any,                 monterey:       "d50d079f076921891e52a22a69d120d8af0a201c12f20517ac10b6ddc60500f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c206ed5bd68705edea06cda0bd96e703f3d46bd91649115a31b8f62d88dc593"
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
