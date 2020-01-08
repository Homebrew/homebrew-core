class Serveit < Formula
  desc "Synchronous server and rebuilder of static content"
  homepage "https://github.com/garybernhardt/serveit"
  url "https://github.com/garybernhardt/serveit/archive/v0.0.3.tar.gz"
  sha256 "5bbefdca878aab4a8c8a0c874c02a0a033cf4321121c9e006cb333d9bd7b6d52"
  revision 1
  head "https://github.com/garybernhardt/serveit.git"

  bottle :unneeded

  def install
    bin.install "serveit"
  end

  test do
    pid = fork { exec bin/"serveit" }
    sleep 2
    assert_match(/Listing for/, shell_output("curl localhost:8000"))
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
