class Rmw < Formula
  desc "Trashcan/recycle bin utility for the command-line"
  homepage "https://theimpossibleastronaut.github.io/rmw-website/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.9.1/rmw-0.9.1.tar.xz"
  sha256 "9a7b93e8530a0ffcd49f1a880e0a717b3112d0ec1773db7349bac416ee1a42b3"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "54b07240896ade22480fe64bbb2eda5327c518ffaef594f934609b55dc97fe79"
    sha256 arm64_monterey: "5fead6bcc25069aac02b5227efeb3a01d1c53742e2d6427204a8b7991ba19613"
    sha256 arm64_big_sur:  "d19a1d0c5634dd8ee234ffbfc680026ce7117a8cbe751aadb38e7ec0463f243e"
    sha256 ventura:        "99514dcb65578f1cfbda839fb10319c1b9babdbbfccfbc742e426f6192ca8a05"
    sha256 monterey:       "1cf338232502a0f45b172f5ba00836ad3f429a1aaa30d150fe187d7c12bb1ad0"
    sha256 big_sur:        "856626a1bed49ede59542a94607b33ba8841bdcf710ef21c4181a51d8daf8e15"
    sha256 x86_64_linux:   "6850a908c22cb35663452467d6ede9681e7fe478b009c91538b4a49c2f5cb788"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "canfigger"
  depends_on "gettext"
  # Slightly buggy with system ncurses
  # https://github.com/theimpossibleastronaut/rmw/issues/205
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
