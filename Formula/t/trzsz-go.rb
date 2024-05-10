class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "ad9f47591d1b2cd6c76e44cf0bcac55906bdff9305d38ad1040bb77529ee3781"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "997b1867fc4bd9ec37e436715a38cf085d16cd14357b44eca4da6f9af94488e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feb6b19dd1dd7dd9cbd7427cd7992a83e9cf0e8fa3c95a4de9b5ff3de4c05993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d0aa11c74a499534f9b617a8808aac63fd9f4023f1f34983c4e986f0880ce3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4433f7c399f58d636a34dbbe1d9d165122c2d9bd98ca03b40bac64ec5e57d9d2"
    sha256 cellar: :any_skip_relocation, ventura:        "d0253209f25ad7b54612e275f6726aa7d861df75b057784688d108fec61777bb"
    sha256 cellar: :any_skip_relocation, monterey:       "c8176abf23c3ae731d80582d2e9ced343d80df5788df78fcd0de318501c005ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d647300179eaedf2b8dd2946df99f41996fad11a4330a4ef3bcba19380a702aa"
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
