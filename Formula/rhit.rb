class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "51cec0ec3addaeb69904e5929ff4d3f8421f4b8630ec772151ef3a475c0a7aa8"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dfde40e1010bed71f65705183f02c82d6123d3396cbe415ea2005d0dc077606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acc2568759d68ee8fe6f6025d9ba6aa862c82ef7e3998d6721eac3659896f780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d726e22f8e9d5f4a015415b5cc62ceefca2323f12b2b5d664711dfeb93791730"
    sha256 cellar: :any_skip_relocation, ventura:        "2b634462bcf0f8b21c7beb4936081403636d128f532cbc6b0628b4e32ed05c29"
    sha256 cellar: :any_skip_relocation, monterey:       "fed23fc40c646b81ffb88646b4db108c9fa8a12c172d8511c5675380a9760189"
    sha256 cellar: :any_skip_relocation, big_sur:        "065efb5cce2cbfabccc0229aec870d3456740c89e4c1516e50237337afcb05ef"
    sha256 cellar: :any_skip_relocation, catalina:       "d2c6a293442c7270de27df91fc562f2f49a4c3ed681faa0cc1bea60b85a37285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3b5255f4ae00a70c62a93017ae41a2147892d002a1a774070f4708012c7cd3"
  end

  depends_on "rust" => :build

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/Canop/rhit/c78d63b/test-data/access.log"
    sha256 "e9ec07d6c7267ec326aa3f28a02a8140215c2c769ac2fe51b6294152644165eb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    resource("homebrew-testdata").stage do
      output = ""
      PTY.spawn("#{bin}/rhit --silent-load --length 0 --color no access.log") do |r, _w, _pid|
        r.winsize = [80, 130]
        begin
          r.each_line { |line| output += line.gsub(/\r?\n/, "\n") }
        rescue Errno::EIO
          # GNU/Linux raises EIO when read is done on closed pty
        end
      end

      assert_match <<~EOS, output
        33,468 hits and 405M from 2021/01/22 to 2021/01/22
        ┌──────────┬──────┬─────┬────────────────────┐
        │   date   │ hits │bytes│0                33K│
        ├──────────┼──────┼─────┼────────────────────┤
        │2021/01/22│33,468│ 405M│████████████████████│
        └──────────┴──────┴─────┴────────────────────┘
      EOS
      assert_match <<~EOS, output
        HTTP status codes:
        ┌─────┬─────┬────┬────┐
        │ 2xx │ 3xx │4xx │5xx │
        ├─────┼─────┼────┼────┤
        │79.1%│14.9%│1.2%│4.8%│
        └─────┴─────┴────┴────┘
      EOS
    end
  end
end
