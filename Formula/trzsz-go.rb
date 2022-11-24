class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "f39c930360a36788f13f26da6792fcce09674e45beb539f0b4b4a747d17576ab"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af0098e11685d21b7b6c81c36181d9ef955c5d28a5102cc6a73ac1c02d13074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aad437a36214ca009504664e5b7b1456bdd41da9fcace5f8c081169c47c6732"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef509e6f7ec1d1153fc0f6ebcb0c8d2fb024eee288a6ce045ef944915cf25086"
    sha256 cellar: :any_skip_relocation, ventura:        "fa2a050f4a267a0d97f48076ab718c924d65af90d1b803f8040bffd2110a57b2"
    sha256 cellar: :any_skip_relocation, monterey:       "ce6c55b0d528f37f34338faf5aac116e38cfbe412c6a72f1c9cd4a42a03510b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "72184ef5f763e546e41fd43b54300ed6e89c2ee8167d06e71f4671ba8b518605"
    sha256 cellar: :any_skip_relocation, catalina:       "025a1b666ee3cad25fe6ac0ef7f4f3469d1ee25f8a88957448f07e7f39b7fa82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e11f58d6a65dbcfc72599ab6938ed3dfc3dec4e38354d8ee232cc053c4319520"
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
