class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "fc2bd613a9ded70906f4c2af67a1540ffe6de165efe6aefeffaea97ceed76a82"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  depends_on "rust" => :build

  uses_from_macos "libiconv"

  resource "testdata" do
    url "https://raw.githubusercontent.com/Canop/rhit/c78d63b/test-data/access.log"
    sha256 "e9ec07d6c7267ec326aa3f28a02a8140215c2c769ac2fe51b6294152644165eb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    resource("testdata").stage do
      PTY.spawn("#{bin}/rhit --silent-load --length 0 --color no access.log") do |r, _w, _pid|
        r.winsize = [80, 130]
        output = r.read.gsub(/\r?\n/, "\n")

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
end
