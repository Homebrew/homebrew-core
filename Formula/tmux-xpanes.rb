class TmuxXpanes < Formula
  desc "Ultimate terminal divider powered by tmux"
  homepage "https://github.com/greymd/tmux-xpanes"
  url "https://github.com/greymd/tmux-xpanes/archive/v2.2.2.tar.gz"
  sha256 "31d5bec7084793f3114119826d961bb85cd0647719587c4b0429a0e7bd4f4495"

  depends_on "tmux" => :recommended

  def install
    system "./install.sh", prefix
  end

  test do
    # Check options with valid combination
    pipe_output "#{bin}/xpanes --dry-run -c echo", "hello", 0

    # Check options with invalid combination (-n requires number)
    output = pipe_output "#{bin}/xpanes --dry-run -n foo -c echo 2>&1", "hello", 4
    assert_equal "xpanes:Error: invalid argument 'foo' for -n option", output.strip
  end
end
