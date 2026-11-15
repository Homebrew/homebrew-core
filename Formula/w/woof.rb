class Woof < Formula
  include Language::Python::Shebang

  desc "Ad-hoc single-file webserver"
  homepage "https://www.home.unix-ag.org/simon/woof.html"
  url "https://codeberg.org/nomis/woof/archive/woof-20260114.tar.gz"
  sha256 "be3afca98352f910b28f89a399aa6d0e24250de93e95d651e8a9775103cc6a78"
  license "GPL-2.0-or-later"
  head "https://codeberg.org/nomis/woof.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "874dadfaaf9de27426d3b1583882ea00c1f88f1f777ccd214023117f5f805d70"
  end

  uses_from_macos "python"

  conflicts_with "woof-doom", because: "both install `woof` binaries"

  allow_network_access! :test

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "woof"
    bin.install "woof"
  end

  test do
    port = free_port
    pid = spawn bin/"woof", "-s", "-p", port.to_s
    sleep 15

    begin
      read = (bin/"woof").read
      assert_equal read, shell_output("curl localhost:#{port}/woof")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
