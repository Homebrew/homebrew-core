class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "765bec16c9216860f11c2d84c94894e4180db1344fc52b389770180fac5cf581"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b377f4e47caff825fa6a996d1f997f19c8ebd5c2a3b15463d6087c42f988600"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b377f4e47caff825fa6a996d1f997f19c8ebd5c2a3b15463d6087c42f988600"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b377f4e47caff825fa6a996d1f997f19c8ebd5c2a3b15463d6087c42f988600"
    sha256 cellar: :any_skip_relocation, ventura:        "0156c7207778df104f8c5eff2906533f6b49fb2f7bcf14389923d00097fabcff"
    sha256 cellar: :any_skip_relocation, monterey:       "0156c7207778df104f8c5eff2906533f6b49fb2f7bcf14389923d00097fabcff"
    sha256 cellar: :any_skip_relocation, big_sur:        "0156c7207778df104f8c5eff2906533f6b49fb2f7bcf14389923d00097fabcff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1067bc86cf40ca1dc345ad0ce087d9910f3a79826c38541f3678f2920141dfa"
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
