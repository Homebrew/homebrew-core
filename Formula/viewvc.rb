class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.2.1/viewvc-1.2.1.tar.gz"
  sha256 "afbc2d35fc0469df90f5cc2e855a9e99865ae8c22bf21328cbafcb9578a23e49"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e630533119aa32963ecdab57a94339c2a4bcf22ec299f970a1aa705352566b76"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e18a6a9766105bad19b6030401ef95c3d8f634c86df22134a2fae667ef7a6e7"
    sha256 cellar: :any_skip_relocation, catalina:      "d56de2b10e8bd8f161071b9d39ae435ee1fc70e4be5056b39d48dec7e77f185e"
    sha256 cellar: :any_skip_relocation, mojave:        "6cd2fbb98cdc1ff4f689aae5ebea8cf4bee6f078671f812c492758274f22a5d6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "19c07a79667814ccb1b14b6214a3d5fcca65ec31381e6e46a5db3ac3f72fc2d4"
  end

  deprecate! date: "2022-10-27", because: "has no python 3 support"

  depends_on :macos # Due to Python 2 (https://github.com/viewvc/viewvc/issues/138)

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
        exec "#{bin}/viewvc-standalone.py", "--port=#{port}"
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
