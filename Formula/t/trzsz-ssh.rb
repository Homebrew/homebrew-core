class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "c85b5ce37afa04fbc770de70da4593a3f335a244dd2610bc1a0d2ba8b0dad752"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f037d189590e38553f7c38ef9401e842ea8559bd5053e14922498632469c43cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "153e8c6e80d3c3c1572fdb6d2f656e360d9987344072f7dc15ccae31152902bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a539391fbdca8693998b50a71f591b83267bd6b78ce5e787d889b65401e490b"
    sha256 cellar: :any_skip_relocation, sonoma:         "581b26e7b2a93254acfd30e0cdad6d726b35680cb622fc02f353c58a1409ca23"
    sha256 cellar: :any_skip_relocation, ventura:        "9263df0c7cf9226af73b87d216dff26e37d392f3e39004ec45f07568bb4eb7f8"
    sha256 cellar: :any_skip_relocation, monterey:       "ebb5c0d9d91d01a9723511584441523c3f00f6e61d9ba8ca6e900b921145b7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57799dd0c6f97f17b768ab73cb9a71928a563748136cf8892b855836a06817ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh --version")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}/tssh -L 123", 255)
  end
end
