class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "a5381d88bc434a4a3db75ef39a86e9351b21b778eb54e7a264bd04863a48bad7"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4d5986998c13973c41b570465f978123fc899337b6ee6accb54d7b4fd87b7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7423336d8a61032802ef01b6117624b517b788f1f7e969957eb69e2e2825fea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7be5b5ed2c7e863bf884cf43c5d0b0eb6e126e787e352d0f94cb35cf8ee3b86e"
    sha256 cellar: :any_skip_relocation, ventura:        "6902048697acb0e8b2ae11cd40c065fe210f921ab03025fd9873123882c839d7"
    sha256 cellar: :any_skip_relocation, monterey:       "158b929d890de826935bde583c3a6775f6ffaa4b4e3bb0a34c7f9a5c4de2ae05"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b5326ab1996014ae1442270f76435f157a0da1df05477eedecab614cb60cd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99fc8a4eee321381a3fcae9b9704a39a246c2281b67c6b9c0ba4ee218a97fb9"
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
