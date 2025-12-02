class Youplot < Formula
  desc "Command-line tool that draw plots on the terminal"
  homepage "https://github.com/red-data-tools/YouPlot/"
  url "https://github.com/red-data-tools/YouPlot/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "126278103f6dbc4e28983b9e90a4e593f17e78b38d925a7df16965b5d3c145a4"
  license "MIT"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "d29e20bfabf80a960825bb2f5eb22b697d946e019683e2844d5a96df3e4c76b5"
    sha256                               arm64_sequoia: "f4f7a0b1d99fc9472d007745a96456a2d87626a21f9e2f1d781b81713904bc71"
    sha256                               arm64_sonoma:  "0154fece0c0a8ddb10acbac21c168b33bacb2839ecc8f0f28d6d7dcf0ebe7047"
    sha256                               arm64_ventura: "4bb2dff5ad2c3ed7d664ef15b09ce44f03b2ec9cb01fa538b6420b9aba56d5c1"
    sha256                               sonoma:        "3373ffb2e43529719160f9be85457e89a87eb20648ca158c4b369b38d762b39c"
    sha256                               ventura:       "b642704f1c8f283ef82b61ece8ee89f5bc758949d36c0f66b3bacd192843b223"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563fd220cab701dd4db2819903e74fea7059cd91963169fafe06518fa4e50535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6afa1c010330d42e76bd3430040c5f289cea496fa805d0fb27a8494a33fd43"
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
