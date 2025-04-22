class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "c98ef2679c7b8c96eed95409138a22904a0550494d191385637e953534d15c75"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "89e60e3e27c13237d8445d2751035fc45a39e61190b9a1d9ebe3616ce9e1ccb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aae20af004ad6c78e0474256666c18b342668c8f7b54d8800968833fbce4861b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "bash" => :test
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
