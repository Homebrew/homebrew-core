class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "3fe31159d6c32c90ec210e13285ae2e82a2b2cecd677c7bcd55363e90cd6103d"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41640d4eab9609fcca1400aafb160e29a169b2ed9e998bc18f8f744ce8628b5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae1251090b125845e64f46b9349f9f62458a37fef56999736b2bc21884daa942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0d1d72c29e09fb78f019f616794738234c95fa27f9017aff402651d81a0e2b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89ddcc212da6c1480439637b6eb132f71dbe2632de9088f89d5a5eae0aaebe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6799083eb9f48ce147a17a0c759b9c823405a6844f2dc9200c87bd59f88e63c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e27b0d43afd1bcde586fa8f4ab06a171764b98c385d6d8d7ec05eae03ef239"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/Canop/rhit/c78d63b/test-data/access.log"
      sha256 "e9ec07d6c7267ec326aa3f28a02a8140215c2c769ac2fe51b6294152644165eb"
    end

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
