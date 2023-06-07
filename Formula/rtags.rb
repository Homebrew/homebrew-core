class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  license "GPL-3.0-or-later"
  revision 1
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
    sha256 cellar: :any, arm64_ventura:  "e9fc47c3d077623542bb1d557a1753b218731de369b03417b05c4670c3b0338d"
    sha256 cellar: :any, arm64_monterey: "3e0a95b35a8a97577ee11285665aafbed32fb82229494d84e87da21bb8789824"
    sha256 cellar: :any, arm64_big_sur:  "7e06083461f28b2d0bd673f4c8d28f71eee2863c176c1d3a47b32509d648cd23"
    sha256 cellar: :any, ventura:        "17776de511c8f419106f1542bdc8973910863dd0b95873133028a8178afdd1f7"
    sha256 cellar: :any, monterey:       "a66d7e8df584032fe4ab59c7bfa2f151ad417d5f764b0af898ee772361a2b27f"
    sha256 cellar: :any, big_sur:        "76efc68ef2d1f22853bacc84defb586b50fedee483480ba3de8c4e3267c455c3"
    sha256 cellar: :any, catalina:       "28fe5726023616ff06c38c985cc2dee21b774d04a539404103fb3e3d8f80320e"
    sha256               x86_64_linux:   "7068920d32be2201832509c35353d275378ef3e549b9b439ac28b5bc7bc4a22f"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@1.1"

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
