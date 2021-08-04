class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "279dfe58a61b9d769f620b6c0552edd93daba75d7761f7c3742ec4d26aaa2962"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "73adbc1522dc396b6fb162e374457445b1ebe45c00e781153857bd779eb7bc1d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "bash" => :test
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
    # The test secript requires network namespace to run, which is not available on Homebrew CI.
    # So here we check the error messages.
    output = shell_output("bash ./test/test-slirp4netns-api-socket.sh 2>&1", 1)
    assert_match "unshare: unshare failed: Operation not permitted", output
  end
end
