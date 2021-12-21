class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "d44dc38ee47e4daad197814aa1e02ae9c87b22571ff19b5ec2697947b9ebe035"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735a23d4671181aeab53080568eef2eb66a7ca286e6187b9c416b11a59fc89ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "315cc35a42cde2f5c39746ede6e17a07950157b10ec14a35f4191deca1a05c72"
    sha256 cellar: :any_skip_relocation, monterey:       "abc1bc29ec9650efbb8e69cf818446be6723e964897a5c1a83ccfe1f201b9c0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "69e7ef10c203f0f4eeb265cb3aff5657b11da914d43aa1cc72d38d2179b9a954"
    sha256 cellar: :any_skip_relocation, catalina:       "48c2bbfea0a9c8aa5eb6a59553013991e713ede0b3679cdd3c0cadeb32e5d536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47715af90a50e5cc5afccc267759e46c37835a47066a90cdcaa145afb127f02"
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
