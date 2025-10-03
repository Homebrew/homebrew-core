class Tinycdb < Formula
  desc "Create and read constant databases"
  homepage "https://www.corpit.ru/mjt/tinycdb.html"
  url "https://www.corpit.ru/mjt/tinycdb/tinycdb-0.81.tar.gz"
  sha256 "469de2d445bf54880f652f4b6dc95c7cdf6f5502c35524a45b2122d70d47ebc2"
  license :public_domain
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?tinycdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd03805a76b700768943e3216fba150262d5fb9f121f1e46e7474c761ce647da"
    sha256 cellar: :any,                 arm64_sequoia: "680cfcfc325b233fe7340563af3250740568b8a3689fae20f477e108ed673a8e"
    sha256 cellar: :any,                 arm64_sonoma:  "345b0faa2f7c6d23974d5c2428eb7961fbf0934a5064e39f1d957469c6ca491c"
    sha256 cellar: :any,                 arm64_ventura: "29a4f84b5a7f2f4eeb6301260a9dd6dc063428a9550bb646b526c3cca3d96565"
    sha256 cellar: :any,                 sonoma:        "00517e16683f21a47b6f985fd00927be4fca3c501aa34e445008aad1f9bbf7ea"
    sha256 cellar: :any,                 ventura:       "c803d0c447413f5d29e43172e75c6a6ac54f6b23b2c85c469e1d0a2930932b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b2c198f26388658e08919e7222f77af9d609383307ba7e87dd29dc781cb7bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e936f20c0ba2216f0ead62448ee2793eb96181c32bb381b9f3207e34e3ce46b5"
  end

  def libcdb_soversion
    # This value is used only on macOS.
    # If the test block fails only on Linux, then this value likely needs updating.
    "1"
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"

    shared_flags = ["prefix=#{prefix}"]
    shared_flags += if OS.mac?
      %W[
        SHAREDLIB=#{shared_library("$(LIBBASE)", libcdb_soversion)}
        SOLIB=#{shared_library("$(LIBBASE)")}
        LDFLAGS_SONAME=-Wl,-install_name,$(prefix)/
        LDFLAGS_VSCRIPT=
        LIBMAP=
      ]
    end.to_a

    system "make", *shared_flags, "shared"
    system "make", *shared_flags, "install-sharedlib"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <fcntl.h>
      #include <cdb.h>

      int main() {
        struct cdb_make cdbm;
        int fd;
        char *key = "test",
             *val = "homebrew";
        unsigned klen = 4,
                 vlen = 8;

        fd = open("#{testpath}/db", O_RDWR|O_CREAT);

        cdb_make_start(&cdbm, fd);
        cdb_make_add(&cdbm, key, klen, val, vlen);
        cdb_make_exists(&cdbm, key, klen);
        cdb_make_finish(&cdbm);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcdb", "-o", "test"
    system "./test"
    return unless OS.linux?

    # Let's test whether our hard-coded `libcdb_soversion` is correct, since we don't override this on Linux.
    # If this test fails, the the value in the `libcdb_soversion` needs updating.
    versioned_libcdb_candidates = lib.glob(shared_library("libcdb", "*")).reject { |so| so.to_s.end_with?(".so") }
    assert_equal versioned_libcdb_candidates.count, 1, "expected only one versioned `libcdb`!"

    versioned_libcdb = versioned_libcdb_candidates.first.basename.to_s
    soversion = versioned_libcdb[/\.(\d+)$/, 1]
    assert_equal libcdb_soversion, soversion
  end
end
