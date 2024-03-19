class Youplot < Formula
  desc "Command-line tool that draw plots on the terminal"
  homepage "https://github.com/red-data-tools/YouPlot/"
  url "https://github.com/red-data-tools/YouPlot/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "aa7339139bc4ea9aa0b2279e4e8052fde673a60ad47e87d50fde06626dc2b3c3"
  license "MIT"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "5790be8d29022d7574e830c5d2e1e994dc99d7c5185ac8cd0d60a49ee740e05e"
    sha256                               arm64_ventura:  "f22e52308aed43e61afdab8fedf9313f605c14413ecfac513d185ec7107fb2c4"
    sha256                               arm64_monterey: "bd9c61e9685720de5cde6a899580055aeab22670a5e106fbed42dbe076ce1353"
    sha256                               sonoma:         "a9f7dc3f7f756c46f2977eedc450306c325edd0773a4b3b1a991b89420c17d17"
    sha256                               ventura:        "88f43ecbfaffb645ba7920297024ca67f4ab52acea27c1f660d8a33c15c98485"
    sha256                               monterey:       "5bd453f72f8a67c46f6df9989c3d26b470da4a4c659e2ff71cc783839663d824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14c5bc2c43beccff2176c088b05202e2a34db3c0d5487a64e33486e2e5046d31"
  end

  uses_from_macos "ruby"

  resource "unicode_plot" do
    url "https://rubygems.org/downloads/unicode_plot-0.0.5.gem"
    sha256 "91ce6237bca67a3b969655accef91024c78ec6aad470fcddeb29b81f7f78f73b"
  end

  resource "enumerable-statistics" do
    url "https://rubygems.org/downloads/enumerable-statistics-2.0.7.gem"
    sha256 "eeb84581376305327b31465e7b088146ea7909d19eb637d5677e51f099759636"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "youplot.gemspec"
    system "gem", "install", "--ignore-dependencies", "youplot-#{version}.gem"
    bin.install libexec/"bin/youplot", libexec/"bin/uplot"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.csv").write <<~EOS
      A,20
      B,30
      C,40
      D,50
    EOS
    expected_output = [
      "     ┌           ┐ ",
      "   A ┤■■ 20.0      ",
      "   B ┤■■■ 30.0     ",
      "   C ┤■■■■ 40.0    ",
      "   D ┤■■■■■ 50.0   ",
      "     └           ┘ ",
      "",
    ].join("\n")
    output_youplot = shell_output("#{bin}/youplot bar -o -w 10 -d, #{testpath}/test.csv")
    assert_equal expected_output, output_youplot
    output_uplot = shell_output("#{bin}/youplot bar -o -w 10 -d, #{testpath}/test.csv")
    assert_equal expected_output, output_uplot
  end
end
