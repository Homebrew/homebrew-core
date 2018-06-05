class Venn < Formula
  desc "Set operations shell script for union, intersection, and more"
  homepage "https://github.com/sixarm/venn"
  url "https://github.com/SixArm/venn/archive/4.3.0.tar.gz"
  sha256 "e40753c31052722d622bd41bd592694642ddb5aa477a6fe0ee6db55e9b847119"

  def install
    bin.install "venn"
  end

  test do
    (testpath/"a").write "red\ngreen\n"
    (testpath/"b").write "red\nblue\n"
    assert_equal "red\ngreen\nblue", shell_output("#{bin}/venn union a b").strip
    assert_equal "red", shell_output("#{bin}/venn intersection a b").strip
    assert_equal "blue\ngreen", shell_output("#{bin}/venn difference a b").strip
    assert_equal "green", shell_output("#{bin}/venn except a b").strip
    assert_equal "blue", shell_output("#{bin}/venn extra a b").strip
    assert_equal "0", shell_output("#{bin}/venn joint a b > /dev/null; echo $?").strip
    assert_equal "1", shell_output("#{bin}/venn disjoint a b > /dev/null; echo $?").strip
  end
end
