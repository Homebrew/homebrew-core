class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.2.tar.gz"
  sha256 "7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "4fb1503d0621917a3ef0ac7e9e797c170f249d090a97eceb2762be751f102e35"
    sha256 big_sur:       "218f06c63577dddf1357cf92c8f66f47ef6ff64f082eea98cce94b62c8a1e00f"
    sha256 catalina:      "3461913e568fce79d103aac72c8edd7e69911f8581133eac8e06759f46b81878"
    sha256 mojave:        "56cd7dbc8cff16da87cb2cc3206c52bba7961401b03e67d73332862133cf780b"
    sha256 x86_64_linux:  "fc3af3d6197b5e2c768266c82efe9b55e80a645d1288cfd9caea53ed353516fc"
  end

  depends_on "ncurses"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "src" do
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      recalc
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/sc-im --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end
