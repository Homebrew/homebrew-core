class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "79079c69149c9d7ec81f5f5a7e705951dc788bc5e300849e3adfef69f8232836"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "e8376b575e1c24235e61e51a32e8152482c3f23ca1baf799bfe52746a92a8112"
    sha256 cellar: :any, x86_64_linux: "81189c095d21a8c56a669aae19748e8ad63b8ab1db973905e5a435d119f6aca7"
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

  resource "homebrew-test-common", :test do
    url "https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.2.1/tests/common.sh"
    sha256 "756149863c2397c09fabbc0a3234858ad4a5b2fd1480fb4646c8fa9d294c001a"
  end

  resource "homebrew-test-api-socket", :test do
    url "https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.2.1/tests/test-slirp4netns-api-socket.sh"
    sha256 "075f43c98d9a848ab5966d515174b3c996deec8c290873d92e200dc6ceae1500"
  end

  deny_network_access!

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
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
