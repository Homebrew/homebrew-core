class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.10.tar.xz"
  sha256 "031de5ebc44b49992c11633f10aae96da05a85b326aebdffd88ba8c445d23cf4"

  bottle do
    cellar :any_skip_relocation
    sha256 "9745dbfa936d7cbeb9223d70641a21b2d0ce8eedc0aee94a46638d2dd7079587" => :catalina
    sha256 "5ac28484f676d5b42a2d98011e5a5f0ec10a3bf6e80dde776deddc801558aa7b" => :mojave
    sha256 "a5ae9f8836f155880cda2a207790e9af093b8bc90a19c768bd9bb243834b48bc" => :high_sierra
  end

  depends_on :macos => :sierra

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
