class Rmw < Formula
  desc "Safe-remove utility for the command-line"
  homepage "https://remove-to-waste.info/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.7.09/rmw-0.7.09.tar.gz"
  sha256 "d0a85944d03e7ec2a94b25d6d6ac92880fd0d3f63d90bb9ed56b16418fd41c69"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git"

  # Slightly buggy with system ncurses
  # https://github.com/theimpossibleastronaut/rmw/issues/205
  depends_on "ncurses"

  def install
    system "./configure", "--enable-debug=no",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    file = testpath/"foo"
    touch file
    assert_match "removed", shell_output("#{bin}/rmw #{file}")
    refute_predicate file, :exist?
    system "#{bin}/rmw", "-u"
    assert_predicate file, :exist?
    assert_match "/.local/share/Waste", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end
