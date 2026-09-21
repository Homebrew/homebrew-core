class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "a27ed4c7311616516b56015cc74fa06c6431f5c8ebadaf331c0e08150d1a84ce"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "cc8a2261521ed5d43eb7cd0dff562f0f54f0c69e5f2801eefe3534f0275433ce"
    sha256 cellar: :any, x86_64_linux: "1f73edeea4d0bbedf1f789c1c93a07ade4ccd6ab8b57ef766b7b1a5fff36b207"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "jq" => :test

  depends_on "glib"
  depends_on "libcap"
  depends_on "libseccomp"
  depends_on "libslirp"
  depends_on :linux

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-test-common" do
      url "https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.2.1/tests/common.sh"
      sha256 "756149863c2397c09fabbc0a3234858ad4a5b2fd1480fb4646c8fa9d294c001a"
    end

    resource "homebrew-test-api-socket" do
      url "https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.2.1/tests/test-slirp4netns-api-socket.sh"
      sha256 "075f43c98d9a848ab5966d515174b3c996deec8c290873d92e200dc6ceae1500"
    end

    resource("homebrew-test-common").stage (testpath/"test")
    resource("homebrew-test-api-socket").stage (testpath/"test")

    # Reduce output to avoid interleaving of commands and stdout
    inreplace "test/test-slirp4netns-api-socket.sh", /^set -xe/, "set -e"

    # The test secript requires network namespace to run, which is not available on Homebrew CI.
    # So here we check the error messages.
    output = shell_output("bash ./test/test-slirp4netns-api-socket.sh 2>&1", 1)
    assert_match "unshare: unshare failed: Operation not permitted", output
  end
end
