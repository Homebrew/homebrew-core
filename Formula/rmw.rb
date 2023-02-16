class Rmw < Formula
  desc "Safe-remove utility for the command-line"
  homepage "https://remove-to-waste.info/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.9.0/rmw-0.9.0.tar.xz"
  sha256 "cc9d20733c9f9945054041ee6aeac7f4a4b7a675f297ffe388e4863fb84ed4a1"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "7f1102ea022d979ee1736eb0abd441013740468146f02c3a61f3856bffd973b6"
    sha256 arm64_monterey: "e9b973e0ab336b1b16d0dc382c17c54fe1e1810fc026d58c2359ef4baa722752"
    sha256 arm64_big_sur:  "5997ee629e5d8f967bee558280199846efb08ef96237ce2e2930d8f71cd14fab"
    sha256 ventura:        "25e56d3fafd47605a39d03f695e2b0277253c90ddea432380fba3be4e87e7019"
    sha256 monterey:       "067944109685808a58fff34cbafde328a429fc99629073c8f27a7f327eb30622"
    sha256 big_sur:        "22c455586c92ed7d09430b2f59b4a2e8dbbca71167025b361fc6ede8b58b212d"
    sha256 catalina:       "278ae8ceb668e433b18cdf27714ad151a177260c1aeba61e17decdd5c90657c4"
    sha256 x86_64_linux:   "23834c1e879ed7df29f94f96d806ec8738f44dd89a032d424b20c02d513ccaf5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "canfigger"
  depends_on "gettext"
  depends_on "ncurses"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Db_sanitize=none", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
