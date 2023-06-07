class Tinycdb < Formula
  desc "Create and read constant databases"
  homepage "https://www.corpit.ru/mjt/tinycdb.html"
  url "https://www.corpit.ru/mjt/tinycdb/tinycdb-0.78.tar.gz"
  sha256 "50678f432d8ada8d69f728ec11c3140e151813a7847cf30a62d86f3a720ed63c"

  livecheck do
    url :homepage
    regex(/href=.*?tinycdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4c19ef1e8ab85e6ea283d3ac801c941e302f8b89e72ed365427890fa7faaa4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58527b40da5f34bf3a0bc6cc83422dcb3e4d9efe05a63473b6e0aa94afdeae73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce0db392cd0f531c5fdc9b3c463a9a26b8389dbb75be6f51bea2fcd0a57bed4e"
    sha256 cellar: :any_skip_relocation, ventura:        "fe718e58e659ea15fd57b46e73ee5e859c364ec413e697e0324c7efd7d196e9a"
    sha256 cellar: :any_skip_relocation, monterey:       "ce44ac08b816e357d2cc5d7ebfb4968ea6a8257e64cb7efb469bd54321e50e98"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e3f2a46d163d0503ac66b177ed0e8ad0848115c782469fd7fa58f49219b4726"
    sha256 cellar: :any_skip_relocation, catalina:       "9493c656d7faf05c57439f251587db9ea5bb6371031f2d08ad04f22398c72a12"
    sha256 cellar: :any_skip_relocation, mojave:         "6ccb5ea327e61b14af89692af32c9fe6fbd9c2d04447ef92970b6f7909fba26b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7b3ca0152fa89592ce48a85cca3aad67b3c1f0ad35e153a52bbb8a772540dd3d"
    sha256 cellar: :any_skip_relocation, sierra:         "a1b2de0589b4530d51f33060657d5c7f08a46d1e90b60f2c2a03f499ff944a4e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4f4341c31d1ed6eddce4dfa57360e339f27f37a0db5b5b6df8df46f5ccda65c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c42225707daf30f28b9da534b084d065d93424c628a5df1ca64de5224221ca81"
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
