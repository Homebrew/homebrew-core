class Rtags < Formula
  desc "ctags-like source code cross-referencer with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      :tag => "v2.3",
      :revision => "da75268b1caa973402ab17e501718da7fc748b34"

  head "https://github.com/Andersbakken/rtags.git"

  bottle do
    rebuild 1
    sha256 "dfe47b80fb392273b464b138e6767b8e6e986f130ea7d8c1183ebff0c19d2d36" => :sierra
    sha256 "d5ec26e73c4339d8dcfb518eed231e2e20529ee13f6bd3c338e2a80f66691de4" => :el_capitan
    sha256 "8ce2ca558e6cfeb123d724a82f293cd392dba6048ba722d475e98d6ffd60077d" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "openssl"

  def install
    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    args = std_cmake_args << "-DRTAGS_NO_BUILD_CLANG=ON"

    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DHAVE_CLOCK_MONOTONIC_RAW:INTERNAL=0"
      args << "-DHAVE_CLOCK_MONOTONIC:INTERNAL=0"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<-EOS.undent
        void zaphod() {
        }

        void beeblebrox() {
          zaphod();
        }
    EOS
    (testpath/"src/README").write <<-EOS.undent
        42
    EOS

    rdm = fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/rdm", "-L", "log"
    end

    begin
      sleep 1
      pipe_output("#{bin}/rc -c", "clang -c src/foo.c", 0)
      sleep 1
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f src/foo.c:5:3")
      system "#{bin}/rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
