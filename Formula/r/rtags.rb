class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags/releases/download/v2.44/rtags-2.44.tar.bz2"
  sha256 "3db5b36216e0b0a98fa7ad1e03a29b2ca7c9d895d85dbe3b2760fcdc2f962db3"
  license "GPL-3.0-or-later"
  head "https://github.com/Andersbakken/rtags.git", branch: "master"

  # The `strategy` code below can be removed if/when this software exceeds
  # version 3.23. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "5ead3132649c1fbcbb5df3a728669d099a3f791f80f3e2c4f561a1cc7c61f414"
    sha256 cellar: :any, arm64_tahoe:       "79281b4fef009adcb15d0589bda97063eec383f920aaa801ba16cfccd9faa307"
    sha256 cellar: :any, arm64_sequoia:     "cc6effbfe02d7ff1092dc60dcb9083c684729f0f26059e68ae5dfaa0eb7a86b7"
    sha256               arm64_linux:       "cf6be132f5fd0ecab7f1c87d3c8950545ad6d11a36cac08cda4965a2e2ccc6b8"
    sha256               x86_64_linux:      "fa0c4fc86a7f1a1f3446d6d951c81c66ff308bdbc7c6bf10f0af750dc58e7fc4"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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

    rdm = spawn "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log", [:out, :err] => File::NULL
    begin
      sleep 5
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 5
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system bin/"rc", "-q"
    ensure
      Process.kill "TERM", rdm
      Process.wait rdm
    end
  end
end
