class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "a28f57ddab8e1a7b721584eb52116662bc3099562ac261d8f3191c2789eeec48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd1533325f273796529ea261a1b416400e5c06d5840f7130cd7645b7a78caff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c337b25fb779d7bac7fecd4305dda7e17bda61a86e4280ebf670d9fe8d23b872"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c2b7bdfdf9b7cf797e58020943093c1cc56850377b722ed39fb657c7ff1789"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdbcdeab61f4e8b86634dbb64b9241451066a0cb9559a15c978cfdb59a1b1c84"
    sha256 cellar: :any_skip_relocation, catalina:       "d09b2b43aacad08622923b249d8af2e411bddd4c3f68c7a9ac86401667051baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb85f8accffe057ef9fe91fe509ebb81a74fbdc79875dcec0807231d3253ffc"
  end

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
