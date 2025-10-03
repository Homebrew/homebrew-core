class Tuntox < Formula
  desc "Tunnel TCP connections over the Tox protocol"
  homepage "https://gdr.name/tuntox/"
  url "https://github.com/gjedeer/tuntox/archive/refs/tags/0.0.10.1.tar.gz"
  sha256 "7f04ccf7789467ff5308ababbf24d44c300ca54f4035137f35f8e6cb2d779b12"
  license "GPL-3.0-only"
  head "https://github.com/gjedeer/tuntox.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bff9afd8a3a6496881f6ad2d4920d3caf40cc4310b6240c989a1cc009e37ea5d"
    sha256 cellar: :any,                 arm64_sequoia:  "a89e240676e2a2acce9e69f80a92d36cf7a15f22668227aec6ac8cbd9aaffcc9"
    sha256 cellar: :any,                 arm64_sonoma:   "880d486454923edadb84110e8a318081260529b455c3efc848333b4ab798bdf9"
    sha256 cellar: :any,                 arm64_ventura:  "820efcfb534b933681932b0563ee91a092dd681e2bdfdcd16acec0f0a5615203"
    sha256 cellar: :any,                 arm64_monterey: "7f5d128f4ce928c72171e3ea664e67c3e0a565beb4a26eb788691b8cabe543be"
    sha256 cellar: :any,                 arm64_big_sur:  "141a9a6dd20c4a5e8d880b4ce10781253ff13d49d1b2492391ae6a1fdc1a0437"
    sha256 cellar: :any,                 sonoma:         "4d32b28b2190221c4868f6066b1a4c7c7922f98365d6e78e702f1f74cd65963b"
    sha256 cellar: :any,                 ventura:        "652bf52893e79c3379b39c8865ab0618a9b6dfe82a40e7cb47b529e8a10d2058"
    sha256 cellar: :any,                 monterey:       "5a94edbe46870d5ba3103cd52264f4e814e7ea366aac1daa4b6a8f3c6e1a6429"
    sha256 cellar: :any,                 big_sur:        "610ffc38571ec6550991c9c055205253b61b74c130da1a1a193d4ad12789b611"
    sha256 cellar: :any,                 catalina:       "028fe7d07cced8a912fe1b8407d03ded470e4883726edcc7a0d4a0fbb14c50c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3c2155cd3b704f8ff29fb52307f2283e88866d35558970169017fafed93ac096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3cac8ddc89ca91fed03ad0907d5ad9ac15c02309a97949b6449d93a7d5449c8"
  end

  depends_on "cscope" => :build
  depends_on "pkgconf" => :build
  depends_on "toxcore"

  def install
    inreplace "gitversion.h", /.*/, '#define GITVERSION "N/A"'
    inreplace "Makefile" do |s|
      s.gsub! "gitversion.h: FORCE", ""
      # -lrt substitution can be removed after 0.0.10.1
      s.gsub! "-lrt", "" if OS.mac?
    end
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    require "open3"

    Open3.popen2e(bin/"tuntox") do |stdin, stdout_err, th|
      pid = th.pid
      stdin.close
      sleep 5
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
