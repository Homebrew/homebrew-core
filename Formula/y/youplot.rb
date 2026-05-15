class Youplot < Formula
  desc "Command-line tool that draw plots on the terminal"
  homepage "https://github.com/red-data-tools/YouPlot/"
  url "https://github.com/red-data-tools/YouPlot/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "126278103f6dbc4e28983b9e90a4e593f17e78b38d925a7df16965b5d3c145a4"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eeb8d9717d60ae7b9dfcd78aacdc79015d4ca8295b7f97fe1edd475ae4792d91"
    sha256 cellar: :any,                 arm64_sequoia: "b2dbf2a7fa893c9113ea3f231d61bde826361916aeab171ffcda8c19f62d7513"
    sha256 cellar: :any,                 arm64_sonoma:  "895212146959ad158fd3ed9a352f23f044abe05cac8f08a2288dc969a7d02ca8"
    sha256 cellar: :any,                 sonoma:        "ef0afa69f04a5b1b718d24ff46ebd7c285ff6d520d54c1f4369c0d4887b45e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dedea3ca0dcb2c889d0f26e9fe2f06f9eb506db2457950066ca15cae852fcc60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823bd972bb4b954f066ef5503fdba09fa90b1c097143201817e06ff4e1be4724"
  end

  depends_on "ruby"

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
    (testpath/"test.csv").write <<~CSV
      A,20
      B,30
      C,40
      D,50
    CSV
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
