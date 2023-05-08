class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "54f8038e55ea92ded8246cc564d0733a39a5a180202f79ccf3870f570ce8b7fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dff98a795eec07c33250e6eeb114727b6d18feef226142ccb3f0cd6d598300c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dff98a795eec07c33250e6eeb114727b6d18feef226142ccb3f0cd6d598300c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dff98a795eec07c33250e6eeb114727b6d18feef226142ccb3f0cd6d598300c"
    sha256 cellar: :any_skip_relocation, ventura:        "28074ea108a9bafe7bcf4ba86698245405429521e0eb12c2fb54077bc5218752"
    sha256 cellar: :any_skip_relocation, monterey:       "28074ea108a9bafe7bcf4ba86698245405429521e0eb12c2fb54077bc5218752"
    sha256 cellar: :any_skip_relocation, big_sur:        "28074ea108a9bafe7bcf4ba86698245405429521e0eb12c2fb54077bc5218752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac815f946813e420d1fbc7569db602c362aa0710ccc15649e9ebcfee9319724"
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
