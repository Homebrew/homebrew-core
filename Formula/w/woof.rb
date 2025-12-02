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
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fb77732fb7843685c636e191145e82994a84ee7eecad8b7c18cc09308eac8362"
  end

  uses_from_macos "python"

  conflicts_with "woof-doom", because: "both install `woof` binaries"

  # patch to not use cgi module (removed in python 3.13)
  patch do
    url "https://github.com/simon-budig/woof/commit/f501798350f98338678832010a26d53f9c33e9d6.patch?full_index=1"
    sha256 "8f4b895081cb177ae9aa9b0acee0c42775d2072495eb31c1a2ae9bccd97cce47"
  end

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
