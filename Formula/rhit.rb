class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "fc2bd613a9ded70906f4c2af67a1540ffe6de165efe6aefeffaea97ceed76a82"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca552a56428686c6744ef22591a078bafa771ad9d10556a3d236a244c349a4a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed8cd1eab1b954f1aaed386a7c4a26df88b45a2c57848797cdea651f7cecb870"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3557bcf168b73c22d2670085069e91f80987ee7c0698b495d10caa90491af9"
    sha256 cellar: :any_skip_relocation, big_sur:        "83c6b1c6d599085aa2980c3b73a5098e9b72304844ccd3a8990e0cb15e4b63ce"
    sha256 cellar: :any_skip_relocation, catalina:       "33d95dff7a169f057a999cd1ea56245277ec17f45a38ce3f5c20a6d4638ee242"
    sha256 cellar: :any_skip_relocation, mojave:         "b0da544cfff128f8f76246e939efe94a6ad34fde368454d482024c5c1ec11c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333de381af53ef46543d691b59d02b734b42bc1444e25905bc8801d727294996"
  end

  depends_on "rust" => :build

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
