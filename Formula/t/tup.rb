class Tup < Formula
  desc "File-based build system"
  homepage "https://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/refs/tags/v0.8.tar.gz"
  sha256 "45ca35c4c1d140f3faaab7fabf9d68fd9c21074af2af9a720cff4b27cab47d07"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "677b1e4dbb495cf13c2b30dd7267cff734c22226cb3720f154c6c7e552036033"
  end

  depends_on "pkg-config" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

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
