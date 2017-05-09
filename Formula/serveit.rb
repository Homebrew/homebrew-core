class Serveit < Formula
  desc "synchronous server and rebuilder of static content"
  homepage "https://github.com/garybernhardt/serveit"
  url "https://github.com/garybernhardt/serveit/archive/v0.0.2.tar.gz"
  sha256 "d7a04f2fbd97f90c31e1838da952cbf5fd8844abeabce0a88569e3d279488ad4"
  head "https://github.com/garybernhardt/serveit.git"

  bottle :unneeded

  depends_on :ruby => "1.9"

  def install
    bin.install "serveit"
  end

  test do
    begin
      pid = fork { exec bin/"serveit" }
      sleep 2
      assert_match /Listing for/, shell_output("curl localhost:8000")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
