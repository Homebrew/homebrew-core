class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  license "GPL-3.0-or-later"
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

  stable do
    url "https://github.com/Andersbakken/rtags.git",
        tag:      "v2.40",
        revision: "8597d6d2adbe11570dab55629ef9a684304ec3cd"

    # fix compiling with gcc 11
    patch do
      url "https://github.com/Andersbakken/rct/commit/31347b4ff91fa6ea68035e0e7b88ed0330016d7f.patch?full_index=1"
      sha256 "9324dded21b6796e218b0f531ade00cc3b2ef725e00e8296c497db3de47638df"
      directory "src/rct"
    end

    # fix lisp files, remove on release 2.42
    patch do
      url "https://github.com/Andersbakken/rtags/commit/63f18acb21e664fd92fbc19465f0b5df085b5e93.patch?full_index=1"
      sha256 "3229b2598211b2014a93a2d1e906cccf05b6a8a708234cc54f21803e6e31ef2a"
    end
  end

  # The `strategy` code below can be removed if/when this software exceeds
  # version 3.23. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v3.23"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "67fde9c9fd4f1ccc4dd3150278f9323974e1a49193f157efb852cd49aa3e6858"
    sha256 cellar: :any, arm64_big_sur:  "271ed75ecc942d6577918b24b7002a5823c0387488d1cdc119858671906fc41d"
    sha256 cellar: :any, monterey:       "1fb01122c1387a7e94fa8a778bee77466b73ee3d4b3f843d06f6bd2d5d0a36e4"
    sha256 cellar: :any, big_sur:        "7d898020bd18e0a52f2e6295ce749c5bd26cbdfadc5b0dd4e03753c875a39e72"
    sha256 cellar: :any, catalina:       "a20866caac99a36a4310a3e157fe898e8dd0e6ed6e2f52e9b397e327060dc2a1"
    sha256               x86_64_linux:   "de2a6f23bb6620c4790fc5c48c2e9306e82d60cfae5e31e48181b6033c98dcd9"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args << "-DRTAGS_NO_BUILD_CLANG=ON"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"rdm", "--verbose", "--inactivity-timeout=300"]
    keep_alive true
    log_path var/"log/rtags.log"
    error_log_path var/"log/rtags.log"
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<~EOS
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    EOS
    (testpath/"src/README").write <<~EOS
      42
    EOS

    rdm = fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log"
    end

    begin
      sleep 1
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 1
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system "#{bin}/rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
