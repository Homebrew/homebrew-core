class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.4.1.tar.gz"
  sha256 "410a547f08557007be0e88194f218868358edc0ab98c98ba8c167930db3d33f9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5383bd15455b9225886712ea256ce3d6d85f32efbc5dd77ca95014cce8db1493"
    sha256 cellar: :any,                 arm64_ventura:  "952aa12ad0725f13b71cfaf0d42b7457d47ec4037e3b50092cdd1eb7c5b5e686"
    sha256 cellar: :any,                 arm64_monterey: "b51c384b3070f37e6a50bf40aa3d2a755d0869033f1f2814bc3a0fa7199281ef"
    sha256 cellar: :any,                 arm64_big_sur:  "2b73d1af4819ca1e387c3ab3f76f78809345e0fa265aef68ab19a8d824facbbe"
    sha256 cellar: :any,                 sonoma:         "11613623a84ec2199b7af04ebf25522184344810167a2c37c854d09bc21b5233"
    sha256 cellar: :any,                 ventura:        "978093e8517ddb0173f7b873074ab75fd7ea546e49dd569656c95c4f8e168e7a"
    sha256 cellar: :any,                 monterey:       "51ac64aee168610e03ab61376b2ab304127faa8cd8361b33d4eff7eabfcca112"
    sha256 cellar: :any,                 big_sur:        "a3c4522b4d6df6ad9a23280aaa22cb03f6e3b029603a04e87e26ee876ffcee9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "556a15c067dac92a37dfe597841e711c18c3e65be2e5dd0f0086f28739df31b3"
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
