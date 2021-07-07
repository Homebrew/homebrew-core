class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "87a8909746781d995b1b49eb36540e6ee745599f983c18f9b4e927ec92d86eb6"
  license "GPL-2.0-only"

  depends_on "jq" => :test

  depends_on "glib"
  depends_on "libcap"
  depends_on "libseccomp"
  depends_on "libslirp"

  resource "source-code" do
    url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.1.11.tar.gz"
    sha256 "87a8909746781d995b1b49eb36540e6ee745599f983c18f9b4e927ec92d86eb6"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("source-code").stage { system "tests/test-slirp4netns-api-socket.sh" }
  end
end
