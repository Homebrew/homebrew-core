class Tinycdb < Formula
  desc "Create and read constant databases"
  homepage "https://www.corpit.ru/mjt/tinycdb.html"
  url "https://www.corpit.ru/mjt/tinycdb/tinycdb-0.80.tar.gz"
  sha256 "c321b905e902c2ca99a3ff8a8dddfd8823247fe1edec8a4bb85f83869c639fb8"
  license :public_domain

  livecheck do
    url :homepage
    regex(/href=.*?tinycdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "778e0ec0b2937521a4b28d1b56d79c6294dc45edb170d99ba3cffe1daf686be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a735eb5b05238cb09e844baeba7f57f3274a8e397b42ec99f44fdde2d885142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edb94ab010ccac6bac74f9ad88aea2fe52c337d87a43f9daaad99255e651dcf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da65daf01c78e36e7c14f2b4a0d8f9b1c701c9bafff107b5bf64f44aabd1a7bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0d9367595ba64cdadc23a8798a05c570cd9424869600e342d08d09d511771a8"
    sha256 cellar: :any_skip_relocation, ventura:        "e006bdc12484c3aca16620ea38529db4f79e184188f3fbe61f983595bc1c5d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "40cabfaada50c310515d55096afb6d3ce13e4828d4c2ab182ee3073f0f7d55c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1964b3b7c3f6a651e96038496216d999171500feb6d1a68c33bf4ce0a7be2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d052ecc7e8be7d542a1492e5f51597ef4b17093bead485a619aaa9a28c3e626"
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
