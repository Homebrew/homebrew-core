class Tinycdb < Formula
  desc "Create and read constant databases"
  homepage "https://www.corpit.ru/mjt/tinycdb.html"
  url "https://www.corpit.ru/mjt/tinycdb/tinycdb-0.78.tar.gz"
  sha256 "50678f432d8ada8d69f728ec11c3140e151813a7847cf30a62d86f3a720ed63c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9493c656d7faf05c57439f251587db9ea5bb6371031f2d08ad04f22398c72a12" => :catalina
    sha256 "6ccb5ea327e61b14af89692af32c9fe6fbd9c2d04447ef92970b6f7909fba26b" => :mojave
    sha256 "7b3ca0152fa89592ce48a85cca3aad67b3c1f0ad35e153a52bbb8a772540dd3d" => :high_sierra
    sha256 "a1b2de0589b4530d51f33060657d5c7f08a46d1e90b60f2c2a03f499ff944a4e" => :sierra
    sha256 "4f4341c31d1ed6eddce4dfa57360e339f27f37a0db5b5b6df8df46f5ccda65c2" => :el_capitan
    sha256 "d73abbd1439c1579c3ab925d2110fee60f287bb9b262850e030c74f7c356bcaa" => :yosemite
    sha256 "b35dda3e5219c993140f7ed6244f483b0159cbd4458fb3ee4461e25daa368d41" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
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
