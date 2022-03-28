class Tcc < Formula
  desc "Tiny C compiler"
  homepage "https://bellard.org/tcc/"
  url "https://download.savannah.nongnu.org/releases/tinycc/tcc-0.9.27.tar.bz2"
  sha256 "de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://repo.or.cz/tinycc.git", branch: "mob"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/tinycc/"
    regex(/href=.*?tcc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 catalina:    "68930891a8746b34b372ecfe43a6a042d0097414713c831353a095135d7b9569"
    sha256 mojave:      "ca8cd4827e72201cd5f368b5b74b9dead8554e0188b7ea63f81926d775d704e9"
    sha256 high_sierra: "1ad7de1b974ca3e16668dec9cbef2accb29ecedb8f3f5819c06a2f77c8f3f2d1"
    sha256 sierra:      "c2949f3a99d1efb600137e4bb617ebd8a385697038f9cb8136c681033a7a636e"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --source-path=#{buildpath}
      --sysincludepaths=/usr/local/include:#{MacOS.sdk_path}/usr/include:{B}/include
      --enable-cross
    ]
    args << "--cc=#{ENV.cc}" if build.head?

    ENV.deparallelize
    system "./configure", *args
    system "make", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make", "install"
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/tcc -run hello-c.c")
  end
end
