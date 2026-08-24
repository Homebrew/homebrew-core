class Skalibs < Formula
  desc "Skarnet's library collection"
  homepage "https://skarnet.org/software/skalibs/"
  url "https://skarnet.org/software/skalibs/skalibs-2.15.1.0.tar.gz"
  sha256 "f9c905e74935c6fe911c7e344e3e89d5fbd2014c1a04650b524b15ce9b5635d1"
  license "ISC"
  head "git://git.skarnet.org/skalibs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8522f1063ab766954841104b3b2dcd79fa419465647450e3e226309cc0c268b7"
    sha256 cellar: :any, arm64_sequoia: "8aa2dbf98365714dbd8d6f4745ffec3e9fe2a05cbbcbc5aee887af5dd75624b8"
    sha256 cellar: :any, arm64_sonoma:  "dd2429c17359fdffdbc50f339ef95cb356c012fd0e0139be55700796bf62a2e6"
    sha256 cellar: :any, sonoma:        "4fa06b2d3f3e0b965beb41c38277b0e175217117565b7fa4e21da1c7df80e892"
    sha256 cellar: :any, arm64_linux:   "0b3aa7c4c3deae00e8a218ffe218015cf4a1d24eb3d40a9ceca3b18bc9a63267"
    sha256 cellar: :any, x86_64_linux:  "ff64368afe3ca42f66ff00390b60513f7fd9e3379da876fff52ad12117a9400a"
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
