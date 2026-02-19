class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.4.4.tar.gz"
  sha256 "55e47994018c13743485544e7206780ffbb3c8495e704a99636503e6e77abf59"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43e94268855378635002149f973c14b5da328ac90a27c1c64556123b8b8866d4"
    sha256 cellar: :any,                 arm64_sequoia: "73396ffac450d962f1b798039a86cbbbeac57e4e1ed922d4fecc03e347585601"
    sha256 cellar: :any,                 arm64_sonoma:  "9d10a64fc6fc482cfb58487a5b8020f819989f91111d4573e2e4160fc391f53e"
    sha256 cellar: :any,                 sonoma:        "e593faad8218064edc4531ecdd7774dfbf1dfdbe612ca538f8058e32d0babd20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f880a4f3119f311fd97e29e14805a8afd85f25a9ad1698fb5818f5202495b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91876f82f97fedcb67b3529e3927390b3056047b3cf0d43cb2741fa289ce399d"
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
