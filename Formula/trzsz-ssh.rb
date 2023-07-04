class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "96889c9ee188f71620b7d7f0935e852b63d8853fd4bd7505260cd87740ee466c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78ded577e32ab61ef2692a5378710cb981973ca6b0d1914af51e496963f4bdc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ded577e32ab61ef2692a5378710cb981973ca6b0d1914af51e496963f4bdc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78ded577e32ab61ef2692a5378710cb981973ca6b0d1914af51e496963f4bdc2"
    sha256 cellar: :any_skip_relocation, ventura:        "2847b99339d9085e6f7d18cbc70529ff2b873f4cf1ddf2206dcd81c613c5d029"
    sha256 cellar: :any_skip_relocation, monterey:       "2847b99339d9085e6f7d18cbc70529ff2b873f4cf1ddf2206dcd81c613c5d029"
    sha256 cellar: :any_skip_relocation, big_sur:        "2847b99339d9085e6f7d18cbc70529ff2b873f4cf1ddf2206dcd81c613c5d029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4f51b2f7ad6d5891881671541346c006cb21bb53c99a4a06affa488365f342"
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
