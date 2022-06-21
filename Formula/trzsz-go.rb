class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "93fb87141bb8306fbb9a465c4cfe5401dd0646bc1180caf1cd50b2503c93e454"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"trz", "./cmd/trz"
    system "go", "build", "-o", bin/"tsz", "./cmd/tsz"
    system "go", "build", "-o", bin/"trzsz", "./cmd/trzsz"
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
