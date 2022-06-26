class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "23f26ffd517949b70f7bc27955f2f219d744dca2bb44a3948ef09206478c678f"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ee8537637917b3736c10f64b06f636d82ae2c0bbfcc8d16136090afcf9b8983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1c725915f80e5bdb5aceb7c7c4baa0fba4e8635aea1a24bd9812f23d4f060fb"
    sha256 cellar: :any_skip_relocation, monterey:       "fe7acd4571c268c8ff198541e8543a262be824f91e751bbc7f63300ce7373785"
    sha256 cellar: :any_skip_relocation, big_sur:        "83e682e5ad0398b86b5c8baae511d6b80112d6a7ef521a673c2543c66e549f00"
    sha256 cellar: :any_skip_relocation, catalina:       "c4c3b42d3dc89abe8fa79c574db51f4f61e5d3dfe02123d69ae974e180e072c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47affaa22c777826881f7f32e55dfcc8abb983b76104debc84b46258b76728b2"
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
