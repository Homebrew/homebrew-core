class Woof < Formula
  include Language::Python::Shebang

  desc "Ad-hoc single-file webserver"
  homepage "https://www.home.unix-ag.org/simon/woof.html"
  url "https://github.com/simon-budig/woof/archive/refs/tags/woof-20220202.tar.gz"
  sha256 "cf29214aca196a1778e2f5df1f5cc653da9bee8fc2b19f01439c750c41ae83c1"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/simon-budig/woof.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cfc359d1f134edad9eb8e9f5fa9542486b3934dfc2c3f56e694c2557460a47b8"
  end

  depends_on "python@3.13"

  conflicts_with "woof-doom", because: "both install `woof` binaries"

  # patch to not use cgi module (removed in python 3.13)
  patch do
    url "https://github.com/simon-budig/woof/commit/f501798350f98338678832010a26d53f9c33e9d6.patch?full_index=1"
    sha256 "8f4b895081cb177ae9aa9b0acee0c42775d2072495eb31c1a2ae9bccd97cce47"
  end

  def install
    rewrite_shebang detected_python_shebang, "woof"
    bin.install "woof"
  end

  test do
    port = free_port
    pid = spawn bin/"woof", "-s", "-p", port.to_s
    sleep 5

    begin
      read = (bin/"woof").read
      assert_equal read, shell_output("curl localhost:#{port}/woof")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
