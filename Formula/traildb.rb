class Traildb < Formula
  desc "Blazingly-fast database for log-structured data"
  homepage "http://traildb.io"
  url "https://github.com/traildb/traildb/archive/0.6.tar.gz"
  sha256 "f73515fe56c547f861296cf8eecc98b8e8bf00d175ad9fb7f4b981ad7cf8b67c"

  bottle do
    cellar :any
    sha256 "858fa4e403f8dcc0590a57f28c28159c4e6276ea8bedde1a16c22fa9d4e9ccd5" => :sierra
    sha256 "2bf6394a161fbc940ca87ede8f68671f1ef8bfc68d4c0d2b0ba1d3de4787e537" => :el_capitan
    sha256 "a9dc4f3be52f86edf47b612a095706ab54b79f24c0606b3839cf5f45f481a851" => :yosemite
    sha256 "68268c2c25c8300b8233d2a652745bbcd2d5d15f5bc54fd49530ba2247591877" => :mavericks
  end

  depends_on "libarchive"
  depends_on "pkg-config" => :build

  resource "judy" do
    url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  def install
    # We build judy as static library, so we don't need to install it
    # into the real prefix
    judyprefix = "#{buildpath}/resources/judy"

    resource("judy").stage do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
          "--disable-shared", "--prefix=#{judyprefix}"
      # Build with -j1 because parallel builds are broken
      system "make", "-j1", "install"
    end

    ENV["PREFIX"] = prefix
    ENV.append "CFLAGS", "-I#{judyprefix}/include"
    ENV.append "LDFLAGS", "-L#{judyprefix}/lib"
    system "./waf", "configure", "install"
  end

  test do
    # Check that the library has been installed correctly
    (testpath/"test.c").write <<-EOS.undent
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
    system "#{bin}/tdb", "make", "-c", "-i", "in.csv", "--tdb-format", "pkg"
  end
end
