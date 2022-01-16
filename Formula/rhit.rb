class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "23f26ffd517949b70f7bc27955f2f219d744dca2bb44a3948ef09206478c678f"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca928f1de76eca9dfbbc2b297195bf95c6f9f9530a4dad0d38fcfe6d9d46df4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d8fd5177ee51f2f348891965310c58b4cc69678234d16f3201967c6128f61fd"
    sha256 cellar: :any_skip_relocation, monterey:       "d1b297050dfe4bc7f2406cd6f37f4dedd0cf69f42cfb23908e830d6587b6e2bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "806016fab2b54ce08a0d05f17de716a1966b2b8b0d316ab56d94b6f206fa784a"
    sha256 cellar: :any_skip_relocation, catalina:       "6c159eabd1477ea08066b8e5418328b31595cba353b410fa7f8428b594b6d882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab570c7ca365e624cb37e91f00102e05cc266e69552c0573c847fd413dc7a9e"
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
