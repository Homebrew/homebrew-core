class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "https://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.2.3/viewvc-1.2.3.tar.gz"
  sha256 "9960fc072201c581735da6eaf589f2129f8bfdf8ff41bef32cf7bbccce10ec60"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "064b7a31c1d2d2679a71c206fde995f01b28e6e38d0cfca699492f37cd130297"
    sha256 cellar: :any_skip_relocation, big_sur:       "50ae5ca9505d4f6ee810972360c6538fdf6e1e028ee3bea7c7b40d7000867ad0"
  end

  disable! date: "2023-11-12", because: "has no python 3 support"

  depends_on :macos # Due to Python 2 (https://github.com/viewvc/viewvc/issues/138)

  depends_on maximum_macos: :big_sur

  def install
    system "python", "./viewvc-install", "--prefix=#{libexec}", "--destdir="
    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?

      bin.install_symlink f => "viewvc-#{f.basename}"
    end
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"viewvc-standalone.py", "--port=#{port}"
      end
      sleep 2

      output = shell_output("curl -s http://localhost:#{port}/viewvc")
      assert_match "[ViewVC] Repository Listing", output
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
