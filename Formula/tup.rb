class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.6.tar.gz"
  sha256 "db8832cf31e9776ea432fe1f9747f6aba6e3d7308331d44c55601e7bec6ab5c6"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
    sha256 "5b630c0ea08ac946d49e0ef52a2c6d6204794885920c53b27e139c6a377a5d6f" => :high_sierra
    sha256 "211ce4e27db6b82a1d3d46bed73e3b41da1e861536890985a0fbbf638f11bebe" => :sierra
    sha256 "35f968fb45943e792b353cec72e7a6233ca5c8f1985b3cbda523a740cc1b46b4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

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
