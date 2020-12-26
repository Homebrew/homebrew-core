class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.01.tar.xz"
  sha256 "d354bbbb1500cfe043c761014dc9c3f62779747fafea8a19af94402327f6d3fc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "33487220d6a3a24f81b309cb880a47054c48da4860c6d45c9aea32350244248a" => :big_sur
    sha256 "768b56ba899e9aabc349d52be4cf32008442c3935935a4f20854f87e1e6bf9fa" => :arm64_big_sur
    sha256 "4d4fc1b89c2f838fb8225e3c8daaf87b55089f4ce176e43a9c10a22f060ef40f" => :catalina
    sha256 "67f141c67e44b867152cc52d91aaaad24ce207c85aee510c1931d56a447930c5" => :mojave
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
