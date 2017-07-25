class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.10.tar.gz"
  mirror "https://sources.voidlinux.eu/talloc-2.1.10/talloc-2.1.10.tar.gz"
  sha256 "c985e94bebd6ec2f6af3d95dcc3fcb192a2ddb7781a021d70ee899e26221f619"

  bottle do
    cellar :any
    sha256 "38c0f818816316884d35564a7230d5aaa2baaeedba74885ce8a4d2f599463228" => :sierra
    sha256 "31766b11cd3bcdcff83e0434ca89d3f4b80a0ab4797d29dd7f25050a63ef2506" => :el_capitan
    sha256 "1ee8d227d6d749743656665ddcfc8538ca9ab2d1b9ff7b46245cd82d622ae94c" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltalloc", "test.c", "-o", "test"
    system testpath/"test"
  end
end
