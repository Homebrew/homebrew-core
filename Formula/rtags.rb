class Rtags < Formula
  desc "ctags-like source code cross-referencer with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      :tag => "v2.3",
      :revision => "da75268b1caa973402ab17e501718da7fc748b34"

  head "https://github.com/Andersbakken/rtags.git"

  bottle do
    sha256 "92ddceb4c7186da6627fc1b607f573cd36fe661b90ece0c5833ff18811c5462b" => :el_capitan
    sha256 "568f12abc4ef51856ebfa3b33373a7003b568ac6447f37ab747a38aac242946f" => :yosemite
    sha256 "2989f3179d501a2617a0ed37e1ed4f89aff0372e687f6724b526539bb329d3c2" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "openssl"

  def install
    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    mkdir "build" do
      system "cmake", "..", "-DRTAGS_NO_BUILD_CLANG=ON", *std_cmake_args
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
