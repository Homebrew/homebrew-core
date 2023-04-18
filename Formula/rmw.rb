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
    sha256 arm64_ventura:  "dfa9abe1e2f9a011a750b2c5d156f364fbf14276419b43d65eddaf6ba963104d"
    sha256 arm64_monterey: "d4a7ec0a94e728d61c0edea0ef5e8e930fd3f036c03230e0843758cc5da7e633"
    sha256 arm64_big_sur:  "7d42d38cd36038303191cf1666d4e4c9bf95a76dcf6d4f183597a7cd77d0093b"
    sha256 ventura:        "25c787a75f8dead6995c96ce43a6035ed84a78d418f782d7fc39a0b457fc9098"
    sha256 monterey:       "b9b8a5f843c5184971f4323487217f8471d3491f557b8e1a8f5f579d29a232eb"
    sha256 big_sur:        "57d4b756b4d21bbd03851ed7afaa8c367ce0a57e39ff91bc478e2be1fe90781f"
    sha256 x86_64_linux:   "49c7b0a3fd748ef20525b71c7171549213442eb8d0753b3e98dd2030bdd7c23f"
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
