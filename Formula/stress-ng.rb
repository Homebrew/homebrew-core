class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.22.tar.xz"
  sha256 "408153d64be1d8a8d584e5f48d9fd09602adf4095a17c0b542cb41e636cf0464"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4e8991beb40f185e6fa563af6348b71d33b9045608dda64816a7893331f254be" => :catalina
    sha256 "255e0391a446c648166f896bf469aa1e15e4207eee8c71cd1c77d89526b59846" => :mojave
    sha256 "811c0f4a9c343c1b4653638d6a01b44bbf76a6405e2576962d802b79b229de97" => :high_sierra
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
