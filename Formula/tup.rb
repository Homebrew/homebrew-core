class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.8.tar.gz"
  sha256 "37baed2d12ef6ce66ce186dc5aa9bcf23098c35d3aee2dc25cb3177eee224b60"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
    sha256 "76c67dc80a2317d0c03e98b90007b6ba0ee4350f0bfbfc6b923b21f7f41be587" => :catalina
    sha256 "fe62bd2762c7ff15e628b6c241c8f6acd81d190c03136c6edce2fd76afafe9f0" => :mojave
    sha256 "9a2e688be1a21af9fc0c2e9edb0e2a679eb7553356e59682037a760c6bd90b8d" => :high_sierra
    sha256 "fc8a299e3ed77a756edbcb957343d1cc95594126f23514eea729649a7fcc6071" => :sierra
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
