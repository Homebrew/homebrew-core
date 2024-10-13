class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.4.2.tar.gz"
  sha256 "85ecf9e465e20f98f9950a52e9a411e14320bc555fa257d87697b7e7a9b1d8a6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7361ad207446544cd094feea0427fd0ff33385232cc51baa5ff1e3939043e215"
    sha256 cellar: :any,                 arm64_sonoma:   "735391b7b483e6445dfbf14c0c45f563d57348edd6f9ba2c62d3d28cb40d73a8"
    sha256 cellar: :any,                 arm64_ventura:  "10a6626844a9157e5b7250db70fc230920a7b216115983e50481ca2ad798277e"
    sha256 cellar: :any,                 arm64_monterey: "4e3a718a021474b1d2fb1d726dd862436079a7af0d1e92a0119cf5eefeff6228"
    sha256 cellar: :any,                 sonoma:         "ff79b75b2642777c53198e3a993e65e5df618a972f2d3bf4f4df8a83443a3a16"
    sha256 cellar: :any,                 ventura:        "a9df241ae263f4f08c0ce968000e213e015633e153668e693db123c06c50b8c7"
    sha256 cellar: :any,                 monterey:       "294d224f5f6f26b9d1a71c747cf42947242e0385235185da48178f5b95e0a380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b80b6e3c9e4ed4bb1ccdaf1d5270e032e99e944cd105f25cc9b295350849e0"
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
    (testpath/"test.c").write <<~EOS
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltalloc", "-o", "test"
    system testpath/"test"
  end
end
