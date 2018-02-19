class Tinycdb < Formula
  desc "Create and read constant databases"
  homepage "http://www.corpit.ru/mjt/tinycdb.html"
  url "http://www.corpit.ru/mjt/tinycdb/tinycdb-0.78.tar.gz"
  sha256 "50678f432d8ada8d69f728ec11c3140e151813a7847cf30a62d86f3a720ed63c"

  # This patch enables install-sharedlib to build a .dylib on macOS.
  patch do
    url "https://gist.githubusercontent.com/zeha/f11da05f59dcef00c7098ac8c988534b/raw/ebfa8035fa2abf04a57b56058c6cce6f402e593e/tinycdb-dylib.patch"
    sha256 "56884df015105f2e408e4b5779162de77c406e2fa2f7952e4f3ffdfffb2b47fc"
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install-sharedlib", "prefix=#{prefix}", "mandir=#{man}"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcdb", "-o", "test"
    system "./test"
  end
end
