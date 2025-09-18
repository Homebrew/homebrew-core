class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.4.3.tar.gz"
  sha256 "dc46c40b9f46bb34dd97fe41f548b0e8b247b77a918576733c528e83abd854dd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48fa5996bb7edeaffed110ccd66edfe54030a38308c4f7eef8b2b3477d7ec10d"
    sha256 cellar: :any,                 arm64_sequoia: "6abdf3d390f094513a2233b594b63358dab2fd6b035b834ecacf18d4671a7b6d"
    sha256 cellar: :any,                 arm64_sonoma:  "afc3f29cd0d83d88010f350f8cb55dc3018c2199363c92c546f9e328b14001c0"
    sha256 cellar: :any,                 arm64_ventura: "d851af75e1e18d20ccf184bd0f1d950f7a364ff676e0e4291220d24795d87bc8"
    sha256 cellar: :any,                 sonoma:        "ba2ccc5ac28845e2d8af43882e17bb552a66543eb635d05526a91088c29598aa"
    sha256 cellar: :any,                 ventura:       "c9a6f30c274ae31febabd3ba18b922beca680f49534ea9cbdafaef0ac7d111f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3feb71b0dd36238cf6739e43a0c902756462912f40b183f4a1764fc94fbaf3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d654af5ac59ff0e6731171fddd996c5fc30d10f2c4387d521bdfa4108c27f818"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <talloc.h>
      int main()
      {
        int ret;
        TALLOC_CTX *tmp_ctx = talloc_new(NULL);
        if (tmp_ctx == NULL) {
          ret = 1;
          goto done;
        }
        ret = 0;
      done:
        talloc_free(tmp_ctx);
        return ret;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltalloc", "-o", "test"
    system testpath/"test"
  end
end
