class Traildb < Formula
  desc "Blazingly-fast database for log-structured data"
  homepage "https://traildb.io/"
  url "https://github.com/traildb/traildb/archive/0.6.tar.gz"
  sha256 "f73515fe56c547f861296cf8eecc98b8e8bf00d175ad9fb7f4b981ad7cf8b67c"
  license "MIT"

  livecheck do
    url "https://github.com/traildb/traildb.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, catalina:    "d838c36b8e7fd566e034374e1fe05e5a2db41940229f7324fec53a2e7387db48"
    sha256 cellar: :any, mojave:      "61992aff616c9e39b703e8b2c138f3997dd9ba7ec6c85eea711605327e221b1f"
    sha256 cellar: :any, high_sierra: "b383a6635462acd29d12473520ff1cf70920c429f0ed9a010cf2860bf7df3180"
    sha256 cellar: :any, sierra:      "e84323b169f8a2d3ccadadb65d968c99265f37f581d9fe002c259b76b180776e"
    sha256 cellar: :any, el_capitan:  "901e2214b9ddcd214b857db69569c12f85041e6cd087df00ef1c0d624605effe"
    sha256 cellar: :any, yosemite:    "381ac2503006105329e6b915501cf8bfdd787121df79c23da4721e04a8b838a9"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "libarchive"

  resource "judy" do
    url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  # Update waf script for Python 3
  patch do
    url "https://github.com/traildb/traildb/commit/12ccff42e73219e2732ffd7f4ee42eb4791bed41.patch?full_index=1"
    sha256 "603f05c8c1eb3117f574eadbd6d0e9c52325245f5a4ba841ac7f0dfc13b37a34"
  end

  def install
    # We build judy as static library, so we don't need to install it
    # into the real prefix
    judyprefix = buildpath/"resources/judy"

    resource("judy").stage do
      ENV.append_to_cflags "-fPIC" if OS.linux?
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
          "--disable-shared", "--prefix=#{judyprefix}"

      # Parallel build is broken
      ENV.deparallelize do
        system "make", "-j1", "install"
      end
    end

    ENV["PREFIX"] = prefix
    ENV.append "CFLAGS", "-I#{judyprefix}/include"
    ENV.append "LDFLAGS", "-L#{judyprefix}/lib"
    system "python3", "./waf", "configure", "install"
  end

  test do
    # Check that the library has been installed correctly
    (testpath/"test.c").write <<~EOS
      #include <traildb.h>
      #include <assert.h>
      int main() {
        const char *path = "test.tdb";
        const char *fields[] = {};
        tdb_cons* c1 = tdb_cons_init();
        assert(tdb_cons_open(c1, path, fields, 0) == 0);
        assert(tdb_cons_finalize(c1) == 0);
        tdb* t1 = tdb_init();
        assert(tdb_open(t1, path) == 0);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltraildb", "-o", "test"
    system "./test"

    # Check that the provided tdb binary works correctly
    (testpath/"in.csv").write("1234 1234\n")
    system bin/"tdb", "make", "-c", "-i", "in.csv", "--tdb-format", "pkg"
  end
end
