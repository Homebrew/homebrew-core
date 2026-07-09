class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https://github.com/rogpeppe/go-internal/tree/master/cmd/testscript"
  url "https://github.com/rogpeppe/go-internal/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "64d134a47c23f8bc4f11ce6048f676a360ab3c44129fc3bcff15cbbb3ae90f78"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a26deb13aba3f2ae2f62f23c7a9f4bada64a62dc4338de386a302e7834c26f7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a26deb13aba3f2ae2f62f23c7a9f4bada64a62dc4338de386a302e7834c26f7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a26deb13aba3f2ae2f62f23c7a9f4bada64a62dc4338de386a302e7834c26f7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "90869015824e67b12111c5aa9bfbc12d8e52c77434195277e71a802ef462d447"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff0ec02a531700cdf7f4e69e143fd6bcffc88e3a165410155b19ecd67fbdaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a02f7a3d0d85341c821030882d7408d3481240ec8cf3228e2551ceb566d946"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/testscript"
  end

  test do
    (testpath/"hello.txtar").write("exec echo hello!\nstdout hello!")

    assert_equal "PASS\n", shell_output("#{bin}/testscript hello.txtar")
  end
end
