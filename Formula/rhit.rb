class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "51cec0ec3addaeb69904e5929ff4d3f8421f4b8630ec772151ef3a475c0a7aa8"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a144f84aa0cc833bbed3531beb7178fea61bc2de09bf50d73282fe86af249a7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a4733b9c78b1d3f903d0a79dad529916d72b5452fd24e33882454cb24249aed"
    sha256 cellar: :any_skip_relocation, monterey:       "1b96477e24e66323fc53ee385d478dd0d62e648470f1ecb5d1cc10b53015dc40"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f1f7f492c158b1ec6df2c1236ecd011cc82271e30678ab7e8ed8e1e7f1e500f"
    sha256 cellar: :any_skip_relocation, catalina:       "0670c75c7b3157ef50cf1b62a8909ea9d75254c513901e7c94c3d71261ad580c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa24d263da8858ef4e9d7cf4ff32beec5e25bbed4a6e8d7c28667c69268bc35"
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
