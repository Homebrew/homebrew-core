class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.10.tar.gz"
  sha256 "c80946bc772ae4a5170855e907c866dae5040620e81ee1a590223bdbdf65f0f8"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
    sha256 "48009935b0e38be19c1d8a0afbbeef75109a970a57327dad9ecf5929b64b7bf2" => :catalina
    sha256 "155b58771fa74a27b20d4e668324ae97ca4c0f8a150691b8ceecd786064dcae1" => :mojave
    sha256 "78c5c8e96892dd07c467f7b86d3312689d33474e7e6a07d4c69905aa60941e10" => :high_sierra
  end

  depends_on "pkg-config" => :build

  on_macos do
    deprecate! date: "2020-11-10", because: "requires FUSE"
    depends_on :osxfuse
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
    doc.install (buildpath/"docs").children
    pkgshare.install "contrib/syntax"
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
