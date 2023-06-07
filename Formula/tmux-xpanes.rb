class TmuxXpanes < Formula
  desc "Ultimate terminal divider powered by tmux"
  homepage "https://github.com/greymd/tmux-xpanes"
  url "https://github.com/greymd/tmux-xpanes/archive/v4.1.4.tar.gz"
  sha256 "617dc90c2c9922bf05e4e9e465b009a0e87fd7931cb5fcf448408cf9ee64c02f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c8e952badcfbef06180a6bb5cc8ee31974b106cb105fd952c0fdbbfc05d36fa"
  end

  depends_on "tmux"

  def install
    system "./install.sh", prefix
  end

  test do
    # Check options with valid combination
    pipe_output("#{bin}/xpanes --dry-run -c echo", "hello", 0)

    # Check options with invalid combination (-n requires number)
    pipe_output("#{bin}/xpanes --dry-run -n foo -c echo 2>&1", "hello", 4)
  end
end
