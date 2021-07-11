class Rmw < Formula
  desc "Safe-remove utility for the command-line"
  homepage "https://remove-to-waste.info/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.8.0/rmw-0.8.0-2.tar.gz"
  sha256 "a01b8472a7cbecc2bed5ba301e360f8defcd77821cef812051d68d4c38f12e95"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "ecedc9da74bf7f1924e0ae29d4d6e1fea649be52a8be434d288c8f8c83903486"
    sha256 big_sur:       "2a9bbccdfb0dd9448defa52f1e3460902e3ee8df6081c96393479da407578ff6"
    sha256 catalina:      "4ba6f35da856f75f91eee16b0fd132ca8740a43187b0851937bbaeb5071457de"
    sha256 mojave:        "223b542bc2cec8a057be459ccdb45ec166f0c7112ba62310191c4a93b2f9f054"
    sha256 x86_64_linux:  "01605f25b81bcf8bd182a152cb8aeb88fc4c8145397ecaecd8d4b353234bb7d3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  # Slightly buggy with system ncurses
  # https://github.com/theimpossibleastronaut/rmw/issues/205
  depends_on "ncurses"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
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
