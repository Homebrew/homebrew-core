class Rmw < Formula
  desc "Safe-remove utility for the command-line"
  homepage "https://remove-to-waste.info/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.8.0/rmw-0.8.0-2.tar.gz"
  sha256 "a01b8472a7cbecc2bed5ba301e360f8defcd77821cef812051d68d4c38f12e95"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "71bcd7c6fbbc2a909c108eafdaf1d0835ffa485fa10b66849fc5e94feb867a18"
    sha256 arm64_big_sur:  "ad98937dac5160507c46d8ee5b1534cd7eb05d67bc63aa53bf5f0f5a79fd63ef"
    sha256 monterey:       "8ff06a7a59fee410da0d4a8c8475da6893f84079ab4dbf0cd14f6642410f1d22"
    sha256 big_sur:        "23b5d0c9666688244a17288ed08968479d83069da180ff78e9dc19c78f218afd"
    sha256 catalina:       "c3da3134ecd1edfad6bbd1c156e38161eb9ba1487e29efd4094ec42c503d66a4"
    sha256 mojave:         "0f86e5bd748141d0b39e2fd5e399cf764d3aec6b0bd24b065f92c24e7e97f8cf"
    sha256 x86_64_linux:   "8be94be0f19f65faa4c19ec1c0898af1439b5488ad51c81e59f30fed3d918a88"
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
