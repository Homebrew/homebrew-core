class Tuntox < Formula
  desc "Tunnel TCP connections over the Tox protocol"
  homepage "https://gdr.name/tuntox/"
  url "https://github.com/gjedeer/tuntox/archive/refs/tags/0.0.10.1.tar.gz"
  sha256 "7f04ccf7789467ff5308ababbf24d44c300ca54f4035137f35f8e6cb2d779b12"
  license "GPL-3.0-only"
  head "https://github.com/gjedeer/tuntox.git", branch: "master"

  depends_on "cscope" => :build
  depends_on "pkg-config" => :build
  depends_on "toxcore"

  def install
    if OS.mac?
      inreplace "Makefile.mac", ".git/HEAD .git/index", ""
      system "make", "-f", "Makefile.mac", "LIB_DIR=#{ENV["HOMEBREW_PREFIX"]}/lib"
    else
      system "make"
    end

    bin.install "tuntox"
  end

  test do
    require "open3"

    Open3.popen2e("#{bin}/tuntox") do |stdin, stdout_err, th|
      pid = th.pid
      stdin.close
      sleep 2
      io = stdout_err.wait_readable(100)
      refute_nil io

      out = io.read_nonblock(1024)

      begin
        assert_includes out, "Using Tox ID"
      ensure
        Process.kill("SIGTERM", pid)
      end
    end
  end
end
