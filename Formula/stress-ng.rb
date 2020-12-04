class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.00.tar.xz"
  sha256 "b2b738f574671926654b1623103a7aa58ee6911894ac78760ee188c4bfa96fe2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e602f8c4cebddb1b670ed8661f66b05c6387a081e930f8884a945e9b9710fa75" => :big_sur
    sha256 "4ab191753c668f9c70335153312e2e40b01b4ab965bfda73692d3177a127f70e" => :catalina
    sha256 "ea78a6865c25a9dd4f65b6d493fa459ff3a0ff272cf71b5d25192e9f53069034" => :mojave
    sha256 "4af7903bbbb13db6f9f4e9fd8cb02a662068d5abf859b2df6049ecfa1b208aec" => :high_sierra
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
