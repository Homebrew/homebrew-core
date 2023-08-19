class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "655ea46ff2b88c7a0530950165b9c005a2cd2afe1ad91516d38edb5fdc56ec2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7db826e62f88560d12fb6792b859048dc5dd90a77190f11dc9fb8909352427a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7db826e62f88560d12fb6792b859048dc5dd90a77190f11dc9fb8909352427a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7db826e62f88560d12fb6792b859048dc5dd90a77190f11dc9fb8909352427a"
    sha256 cellar: :any_skip_relocation, ventura:        "e4dec434f41381a15b096ff3a908ff9f7e16e38a5eb2f29b12aa9e13354fc1a4"
    sha256 cellar: :any_skip_relocation, monterey:       "e4dec434f41381a15b096ff3a908ff9f7e16e38a5eb2f29b12aa9e13354fc1a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4dec434f41381a15b096ff3a908ff9f7e16e38a5eb2f29b12aa9e13354fc1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f8195b2c85f3f080d863e9117d2e1cc6b9f40ea57bd9d206d866e81a579452"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trz"), "./cmd/trz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tsz"), "./cmd/tsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trzsz"), "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version 2>&1")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version 2>&1")

    assert_match "Wrapping command line to support trzsz", shell_output("#{bin}/trzsz 2>&1")
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end
