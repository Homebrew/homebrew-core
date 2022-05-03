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
    sha256 cellar: :any, arm64_monterey: "21c16d5289676a51fdb9736631ed86d12b27d9c0c8034baa310c79f95dd51497"
    sha256 cellar: :any, arm64_big_sur:  "4031ba7d9c52f3834e868c716b04854d45a234312a55a9e31c26bf18c01cce8c"
    sha256 cellar: :any, monterey:       "98d9a9608ab4360ee8aba0269feabada932c622ec2cd1150db8c00c9efe80061"
    sha256 cellar: :any, big_sur:        "b27afadc735d740bcb9ca96d1a9ea5fd77f0c07b663b10b7a09f3c10e696614f"
    sha256 cellar: :any, catalina:       "dcaf7b5babf605732fd9007de2f2196687601f839c4045e9eee26ba4ed641cb7"
    sha256               x86_64_linux:   "580e835fcc2d725ad8abfa7cd62d653ec100f9c9f84801fa4886ba3b84f6c804"
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
