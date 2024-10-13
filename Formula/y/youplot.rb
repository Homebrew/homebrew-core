class Youplot < Formula
  desc "Command-line tool that draw plots on the terminal"
  homepage "https://github.com/red-data-tools/YouPlot/"
  url "https://github.com/red-data-tools/YouPlot/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "126278103f6dbc4e28983b9e90a4e593f17e78b38d925a7df16965b5d3c145a4"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia:  "38af94e0b042576027ea48ddacfa7328a06da03115fd979ffe51ea78f20cce04"
    sha256                               arm64_sonoma:   "34886703341b58e351283223a6fe19717d404120c709ed1a518753ac07f16e85"
    sha256                               arm64_ventura:  "224f2643f50bbd531e19ec45f9a56ec760304379a943420a42c0038b0d5ca2c2"
    sha256                               arm64_monterey: "e2f7ef7149fec5451496cdc50394a718084180d792d08f7b7db3085db1f56fa3"
    sha256                               sonoma:         "15297f02a8a7176c2cae1a2f541ce7bd8884b15d097070b8882ad6e2fc54d7a6"
    sha256                               ventura:        "3ed832d8288148f3ce99bb857538dabcdca8821e33215db6910c2c0f7075a9ae"
    sha256                               monterey:       "0ab163b9eb0c815a52b0ae4122d3e7ac41c2ad885c39b7106e0bd1b909cd3f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e036b00579b5ab8dab662523782303690222a42b3f21197769191c690f1adb87"
  end

  uses_from_macos "ruby"

  resource "enumerable-statistics" do
    url "https://rubygems.org/downloads/enumerable-statistics-2.0.8.gem"
    sha256 "1e0d69fcdec1d188dd529e6e5b2c27e8f88029c862f6094663c93806f6d313b3"
  end

  resource "unicode_plot" do
    url "https://rubygems.org/downloads/unicode_plot-0.0.5.gem"
    sha256 "91ce6237bca67a3b969655accef91024c78ec6aad470fcddeb29b81f7f78f73b"
  end

  resource "csv" do
    url "https://rubygems.org/downloads/csv-3.3.0.gem"
    sha256 "0bbd1defdc31134abefed027a639b3723c2753862150f4c3ee61cab71b20d67d"
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
