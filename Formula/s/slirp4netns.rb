class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "c8e445deded09c5e777af3c599f808b3d0cbfeab482d9e76746df0926234200d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a95ecc25c04aeed64f4e062fe75b713a7d9657773ef6bce3af043abab51cf702"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "296a13f34910d8cd1dc4f8e9f71fd163df2f1114b181cc6ea7569345946e64ad"
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
