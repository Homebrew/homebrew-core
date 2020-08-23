class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.18.tar.xz"
  sha256 "07c82a5c89538b5b696a79192faa70d0232352004c9e532946f7f3613d0adf23"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e049dcd01ec4b4f3a60e5cb54ebe6be5c083130859b297c63e767cecf24890b" => :catalina
    sha256 "866d91a80f928888bd171fa93894d87d0688f8ece209c5bf62e916ef677528f9" => :mojave
    sha256 "b0a0ee1d1f9ddb42d335bcd2cfad3070471fd5fc26a034fd2a9530161b7ac1c1" => :high_sierra
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
