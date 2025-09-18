class Tcc < Formula
  desc "Tiny C compiler"
  homepage "https://bellard.org/tcc/"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://repo.or.cz/tinycc.git", branch: "mob"

  stable do
    url "https://download.savannah.nongnu.org/releases/tinycc/tcc-0.9.27.tar.bz2"
    sha256 "de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c"

    depends_on arch: :x86_64
    # Big Sur and later are not supported
    # http://savannah.nongnu.org/bugs/?59640
    depends_on maximum_macos: :catalina
  end

  livecheck do
    url "https://download.savannah.nongnu.org/releases/tinycc/"
    regex(/href=.*?tcc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 catalina:     "68930891a8746b34b372ecfe43a6a042d0097414713c831353a095135d7b9569"
    sha256 x86_64_linux: "053f79a5752554e18ecba168184e48481bce8a2db418a3f9b0de094f9e6d0e4d"
  end

  # Last release on 2017-12-17 and currently only builds on single runner (x86_64 linux).
  # The HEAD mob branch unmoderated so not ideal to use an arbitrary commit.
  deprecate! date: "2025-09-16", because: :unsupported

  def install
    # Add appropriate include paths for macOS or Linux.
    os_include_path = if OS.mac?
      MacOS.sdk_path/"usr/include"
    else
      "/usr/include:/usr/include/x86_64-linux-gnu"
    end

    args = %W[
      --prefix=#{prefix}
      --source-path=#{buildpath}
      --sysincludepaths=#{HOMEBREW_PREFIX}/include:#{os_include_path}:{B}/include
      --enable-cross
    ]
    args << "--cc=#{ENV.cc}" if build.head?

    ENV.deparallelize
    system "./configure", *args

    make_args = []
    make_args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "make", *make_args
    system "make", "install"
  end

  test do
    (testpath/"hello-c.c").write <<~C
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    C
    assert_equal "Hello, world!\n", shell_output("#{bin}/tcc -run hello-c.c")
  end
end
