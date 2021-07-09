class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "87a8909746781d995b1b49eb36540e6ee745599f983c18f9b4e927ec92d86eb6"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "jq" => :test

  depends_on "glib"
  depends_on "libcap"
  depends_on "libseccomp"
  depends_on "libslirp"
  depends_on :linux

  resource "test-common" do
    url "https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.1.11/tests/common.sh"
    sha256 "162042d762d36a1e353c79d763a1da9e0e338daee6aae439226c87b2c24d02f6"
  end

  resource "test-api-socket" do
    url "https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.1.11/tests/test-slirp4netns-api-socket.sh"
    sha256 "c5f182ec7203c4c6af8e80de1cd9dc68ed09adefb07054558161ee8889eb1ffa"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("test-common").stage (testpath/"test")
    resource("test-api-socket").stage (testpath/"test")
    system "sh", "./test/test-slirp4netns-api-socket.sh"
  end
end
