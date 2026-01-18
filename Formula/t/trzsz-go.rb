class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6577fbab008264ff4678f60f56a0dea1e68763064a638eaf54e560198a5e6fd3"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a5410c23c2797a9ef8e138d8b14c20692f6bfb57c49ad1bc90695b3a82c7be1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a5410c23c2797a9ef8e138d8b14c20692f6bfb57c49ad1bc90695b3a82c7be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a5410c23c2797a9ef8e138d8b14c20692f6bfb57c49ad1bc90695b3a82c7be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "543ceb3a77cbe35f909e9f7ad3a8693d33fba9182cc1acc982e81847d3e11783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6236f50a93b7c1505c207ddfe9d1d31bba7d98c9dcacf32fe8e0a1fedb806d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59fac615831aa88294932a9819feb45342ac643d109eac084a1ee5f042e1f6c3"
  end

  depends_on "go" => :build

  conflicts_with "trzsz", because: "both install `trz`, `tsz` binaries"

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
