class Youplot < Formula
  desc "Command-line tool that draw plots on the terminal"
  homepage "https://github.com/red-data-tools/YouPlot/"
  url "https://github.com/red-data-tools/YouPlot/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "126278103f6dbc4e28983b9e90a4e593f17e78b38d925a7df16965b5d3c145a4"
  license "MIT"
  revision 2

  bottle do
    sha256                               arm64_tahoe:   "1c739f9e27747bdbec27e82a88c3cc9ce882974a6918a3815cf5547d19f255e3"
    sha256                               arm64_sequoia: "3188353334f66de3bc164af96efd052c0cd7041164d7f04be0fe6d24bdb0d66d"
    sha256                               arm64_sonoma:  "02fa87a89be61f440f0729e7b2a89f51a898e7a94f167500244de0d345988d1b"
    sha256                               sonoma:        "c0f738a4dd673db99a6541d7ec7a94314c7d9823a6a543902f1a090c39ed46b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5765565dd1195a9709e85821ae349f88b87b4519fc27f6305260460d6e4eb545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf27ee6dd3a4fc889a2d085f897132c2586462351eb9e8731e8b8bd6952afb7"
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
