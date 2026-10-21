class Xwpe < Formula
  desc "Borland-style IDE clone with LSP/DAP support (terminal UI)"
  homepage "https://codeberg.org/mendezr/xwpe"
  url "https://codeberg.org/mendezr/xwpe/releases/download/v1.6.9/xwpe-1.6.9.tar.gz"
  sha256 "14499a7a4f5193bf23f539285adf7156054c5bfe6b20b991e705e3c3a5f6b392"
  license "GPL-2.0-or-later"
  head "https://codeberg.org/mendezr/xwpe.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "3c9969071fe4a1d90908a343c4cf6fbfed7e754aae52519bb9386268cd4201a9"
    sha256 arm64_tahoe:       "c5f25065066d35c1489cfdd1b2da866525c282609b62d807694e3afda2ca297e"
    sha256 arm64_sequoia:     "fa4762b46bb0d24295b486fbb7fab42e355b22f0e6959a0a098ab4ad42d2c400"
    sha256 arm64_linux:       "78c367bb664ba50ba49f1625df905286142344b93b11bbeeb62233b08e8703ff"
    sha256 x86_64_linux:      "fb963dd6dc2529793c917ec9dd3043192c03f1dee70be8946f7529da8580cac5"
  end

  depends_on "pkgconf" => :build

  depends_on "json-c"
  depends_on "libvterm"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # The release tarball is a `make dist` archive: it ships a working configure
    # and the pre-built Texinfo pages (docs/xwpe.info), so no autoreconf or
    # makeinfo run is needed.
    system "./configure", "--without-x", "--without-gpm", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    require "pty"
    require "io/console" # IO#winsize=

    # xwpe is a full-screen TUI editor (vim/nano-style), not a CLI filter: it
    # never exits with an error on its argument. Drive the real editor under a
    # pseudo-terminal on three kinds of input and assert its behaviour by liveness
    # and on disk -- ground truth that does not depend on scraping the screen or
    # on any one keystroke firing, so it is robust on every platform. A hard kill
    # bounds each run, so the test can never hang.
    ENV["TERM"] = "xterm-256color"

    # Open `arg` in wpe for `secs`; return whether it was still running (i.e. it
    # opened the input without crashing), then hard-kill it.
    open_briefly = lambda do |arg, secs|
      r, _w, pid = PTY.spawn((bin/"wpe").to_s, arg.to_s)
      r.winsize = [24, 80]
      sleep secs
      alive = Process.waitpid(pid, Process::WNOHANG).nil?
      begin
        Process.kill "KILL", pid
        Process.waitpid pid
      rescue Errno::ESRCH, Errno::ECHILD
        nil
      end
      r.close
      alive
    end

    # 1) A normal file: xwpe opens it and keeps running, without corrupting it.
    normal = testpath/"normal.c"
    normal.write("int main(void) { return 0; }\n")
    original = normal.read
    assert open_briefly.call(normal, 4), "xwpe crashed opening a normal file"
    assert_equal original, normal.read

    # 2) A file it cannot read/write: a read-only (0444) file opens read-only --
    #    xwpe keeps running and leaves the bytes untouched.
    readonly = testpath/"ro.c"
    readonly.write("ORIGINAL\n")
    readonly.chmod(0444)
    assert open_briefly.call(readonly, 4), "xwpe crashed opening a read-only file"
    assert_equal "ORIGINAL\n", readonly.read

    # 3) A directory: xwpe opens its built-in file manager and keeps running,
    #    rather than erroring or crashing.
    assert open_briefly.call(testpath, 4), "xwpe crashed opening a directory"
  end
end
