class Tcc < Formula
  desc "Tiny C compiler"
  homepage "https://bellard.org/tcc/"
  url "https://download.savannah.nongnu.org/releases/tinycc/tcc-0.9.27.tar.bz2"
  sha256 "de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c"

  bottle do
    sha256 "6e8aa202c393f2788c2f6c6ff43ee9b515e2eeb7a21118f92ce67a53ad0e8624" => :high_sierra
    sha256 "e54350d4d114a0ceabe1d59176d12578e17fc63ebba65fc8c35dc347f02a6daa" => :sierra
    sha256 "2e5a483599bcb577bc421db239bc5e53d4c31ad8ca5111c9a264f5c3d71c5266" => :el_capitan
  end

  option "with-cross", "Build all cross compilers"

  def install
    args = %W[
      --prefix=#{prefix}
      --source-path=#{buildpath}
      --sysincludepaths=/usr/local/include:#{MacOS.sdk_path}/usr/include:{B}/include
    ]

    args << "--enable-cross" if build.with? "cross"

    ENV.deparallelize
    system "./configure", *args
    system "make"
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
