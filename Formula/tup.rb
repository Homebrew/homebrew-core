class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.9.tar.gz"
  sha256 "9b0951afaa749186eb55d88860405b2f6b3d88632d1b5df1ec4a0bf973d8d326"
  license "GPL-2.0"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
    sha256 "6a6730ccbf131493bfd3f35b4e38f50a60cbefb122794ab603b6ad2e7fba2f28" => :catalina
    sha256 "d1d2207224fb78fd4f1dcdbfacf2b62b10538ebacccd33356c5e93fcedad030e" => :mojave
    sha256 "9e45e8c40a8576611ba6fa53a55c9004b31f41af75c9130ba909012ec19fef45" => :high_sierra
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
