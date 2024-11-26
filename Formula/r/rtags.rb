class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  license "GPL-3.0-or-later"
  revision 3
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
    sha256 cellar: :any, arm64_sequoia: "7cbafd2962f2d48c3c6039a629551f7d6622ce4ac98f59bf77720bb8ae77dd74"
    sha256 cellar: :any, arm64_sonoma:  "bb206bede3bd73fbfef3fc8cbe547f9b8dbe00a788f34470e6fdd1a4e1f3448e"
    sha256 cellar: :any, arm64_ventura: "2179553e6e583a3f45e0473cab00aa2475a663b6a766b3e57eca70b74bcbd174"
    sha256 cellar: :any, sonoma:        "8dba70a31d59037e8291637367451f6d51c32176e0f49165a921a43dee6737dd"
    sha256 cellar: :any, ventura:       "7443ddcafb2ec4841d5b86893a0b7935f47615fc6e8eb173705e94564a08b097"
    sha256               x86_64_linux:  "16ce83f28f301d27a3d8a127c5eed780b0e974014c075123147a2e14727b793a"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DRTAGS_NO_BUILD_CLANG=ON", *std_cmake_args
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
    (testpath/"src/foo.c").write <<~C
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    C
    (testpath/"src/README").write <<~EOS
      42
    EOS

    rdm = fork do
      $stdout.reopen(File::NULL)
      $stderr.reopen(File::NULL)
      exec "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log"
    end

    begin
      sleep 5
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 5
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system bin/"rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
