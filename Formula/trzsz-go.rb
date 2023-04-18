class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "28714b3c0715796935cec8bb20e98a3ae06e91c5817fdc735bdc4d1f55dee78c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24918d6a5d1d736baa4f465e1ee46ad38e50ca0fb2dd4566821e3952732560bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "160e3e935dd35f53d29ac8da911d8e3c3cc50338a722becd9ae22f442fe0a429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68466d29ab1a193545f0e3b55108d2bdd51921e4293feb38dff71cf114f2d624"
    sha256 cellar: :any_skip_relocation, ventura:        "5d1cefe99e950a6a85e17dc68b4fb918a80a6b35005833041a940e3f64feb6c5"
    sha256 cellar: :any_skip_relocation, monterey:       "47f4abde1eae9aa0f8b92c9bdfc4fbcdcd2bb8c23795b2d6723b0a82028fc693"
    sha256 cellar: :any_skip_relocation, big_sur:        "71ec72570caa68a61ead80c167f5d56bbf10532d7a3bbcb4c98875a363c85074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20695b59fa9b52f9fa16f0c56a04a9e1897b77ed1411ffa87544baddf8e14895"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trz"), "./cmd/trz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tsz"), "./cmd/tsz"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"trzsz"), "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version")

    assert_match "executable file not found", shell_output("#{bin}/trzsz cmd_not_exists 2>&1", 255)
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end
