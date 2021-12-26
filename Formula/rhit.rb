class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "76236126f3918e606e3fa333f06e7316ab85d5783a29c59ea893e58ec1bfa96a"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b04aef293eceac654def1efb765679ba126694cc7ae8737f37a06c6ca7d0229d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3470bb87150f4976d3bcfe050071d4f8183773c774e5f6bee7dc54d6f9367e9a"
    sha256 cellar: :any_skip_relocation, monterey:       "0b97584715c6ca831ba81bc67fbc8b050f5c8c20e14d0dddb7664f55e372c09e"
    sha256 cellar: :any_skip_relocation, big_sur:        "164319fbcb499ad1cf022fd99a7200a040da0bf3ffb7550a81de8a7e829dd01c"
    sha256 cellar: :any_skip_relocation, catalina:       "cebb57ee273b34070d74656d888acfc8b8fa7daa67c84c341b7e51708eb93729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7db13dc558b48b208e2c21c7aa18b6fad42530a776435ab92b01b3b45925b87"
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
