class Skalibs < Formula
  desc "Skarnet's library collection"
  homepage "https://skarnet.org/software/skalibs/"
  url "https://skarnet.org/software/skalibs/skalibs-2.14.5.1.tar.gz"
  sha256 "fa359c70439b480400a0a2ef68026a2736b315025a9d95df69d34601fb938f0f"
  license "ISC"
  head "git://git.skarnet.org/skalibs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4eb73f6bdf652ecf3af6de5e1a5787859ee1a1a1302ad206d0002dc2025d7c0f"
    sha256 cellar: :any,                 arm64_sequoia: "ad6efbfa0735a8b2631879d7bd78dcf079dff7e1e42ad39ac40f717150bdb220"
    sha256 cellar: :any,                 arm64_sonoma:  "8e2e99a71a62d9cdf208e51ba32b2c73e879ed08c07346af31da5be916e23136"
    sha256 cellar: :any,                 sonoma:        "fc799c27290009fde32c04b2200aa26ec3af29ad7783291234b9add2ef4a0aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951ca76a43921290ecc07b50d4a876313b2a675ff57082d352147e20892b40f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3769660ce34bb62ccc6f47a0f1c8ff60d5b11e2ed038c04bef62d593c4bb5488"
  end

  def install
    args = %w[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <skalibs/skalibs.h>
      int main() {
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lskarnet", "-o", "test"
    system "./test"
  end
end
