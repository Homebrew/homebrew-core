class Woof < Formula
  include Language::Python::Shebang

  desc "Ad-hoc single-file webserver"
  homepage "http://www.home.unix-ag.org/simon/woof.html"
  url "https://github.com/simon-budig/woof/archive/woof-20220202.tar.gz"
  sha256 "cf29214aca196a1778e2f5df1f5cc653da9bee8fc2b19f01439c750c41ae83c1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b65de07c5c918fb82b3c7a047c4c22c2771ef3897cd2f3c1abb64a76a7a867d"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "woof"
    bin.install "woof"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/woof", "-s", "-p", port.to_s
    end

    sleep 2

    begin
      read = (bin/"woof").read
      assert_equal read, shell_output("curl localhost:#{port}/woof")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
