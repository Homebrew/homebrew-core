class Youplot < Formula
  desc "Command-line tool that draw plots on the terminal"
  homepage "https://github.com/red-data-tools/YouPlot/"
  url "https://github.com/red-data-tools/YouPlot/archive/v0.4.5.tar.gz"
  sha256 "aa7339139bc4ea9aa0b2279e4e8052fde673a60ad47e87d50fde06626dc2b3c3"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "60e92af5e86cc5c29a923a12470c36b6c1bdbe9e3d0549ce483b45974494a090"
    sha256                               arm64_monterey: "397cf683916a6b62eb8ac1a8ca98bb56d3ca3d9fdd725f40702d6f72c7e2bf4b"
    sha256                               arm64_big_sur:  "6a0cc141b2dfc5bcd7a28666ca181799d5b6fbf48dca90ac64e582e7225810a2"
    sha256                               ventura:        "13fedf180b967115571c03890214d65cfcaf8607acda2a75dea5b263c47ee3cb"
    sha256                               monterey:       "c2d9cddf97b15b474f181f318f97a24a50e50e7e7ca71922cb97248d13935383"
    sha256                               big_sur:        "fbc41b8190ca616ba3794aa5d75fc9121cb15e303fc2f4a7df0926bc74468ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c14eb0b846c089762f066aef1f2cda5093012274234b92023a331a1bf8e93bdc"
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
