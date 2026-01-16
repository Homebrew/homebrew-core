class Tup < Formula
  desc "File-based build system"
  homepage "https://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/refs/tags/v0.8.tar.gz"
  sha256 "45ca35c4c1d140f3faaab7fabf9d68fd9c21074af2af9a720cff4b27cab47d07"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/gittup/tup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "04d0f54b9afb1fd40a96877e366db5a482b201e01e2d5bde296c618c1738314d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2d1f0921353b16d91b7e91ad6bbaf443f784eebb3f9d1f2ce22058e3e888d9f5"
  end

  depends_on "pkgconf" => :build
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
    system bin/"tup", "-v"
  end
end
