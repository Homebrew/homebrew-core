class Tcc < Formula
  desc "Tiny C compiler"
  homepage "https://bellard.org/tcc/"
  url "https://download.savannah.nongnu.org/releases/tinycc/tcc-0.9.27.tar.bz2"
  sha256 "de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c"
  revision 1

  bottle do
    rebuild 1
    sha256 "697164b3427d1993923e2e4c446b4ea87b55916d59cfe5ba64ad04ca3d54bddc" => :mojave
    sha256 "45a2646746c8a9766aa106ba6aaac155e8b963c2c5ea3afac0b398b0b5501430" => :high_sierra
    sha256 "f5ce8a5801502da6c214ad9f5e9df024109bbe0c4e5380de35112f0596a373fe" => :sierra
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --source-path=#{buildpath}
      --sysincludepaths=/usr/local/include:#{MacOS.sdk_path}/usr/include:{B}/include
      --enable-cross"
    ]

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
