class Tinycdb < Formula
  desc "Create and read constant databases"
  homepage "https://www.corpit.ru/mjt/tinycdb.html"
  url "https://www.corpit.ru/mjt/tinycdb/tinycdb-0.81.tar.gz"
  sha256 "469de2d445bf54880f652f4b6dc95c7cdf6f5502c35524a45b2122d70d47ebc2"
  license :public_domain

  livecheck do
    url :homepage
    regex(/href=.*?tinycdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84a0722cb1e3e74c5771ddf3e58ec4c6181baac4705e9d8c824b5c1a943b7b29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56128230eae3a7c00d7673e75878e87b17c29a1a417934f8f70e20d7672adff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3c14e7e96bf04a5732dbe8f3004368a95cfcfb5e8f9cc3efad43b8d4eb39982"
    sha256 cellar: :any_skip_relocation, sonoma:         "244ae0d966d0d1ccd93c3a9c23983865a89cf4da0859a87fc84021ca56ad55b8"
    sha256 cellar: :any_skip_relocation, ventura:        "d15dfde4eaf2332e3a362020c1a46eebc4aadb429bb08650f094c26d49e39601"
    sha256 cellar: :any_skip_relocation, monterey:       "90dcf17edde006c16827865c1448fcb9a6c0bf1eee39eca0be8e41253fc0031d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d208e49ab4a661837a4490712ad50e7cbca6b240cbf9e91b4d8989d113707cfe"
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
