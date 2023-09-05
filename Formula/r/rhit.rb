class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "b01b7207ca819e741b635e7751bbf9074c9eb9e97f0483c31e560f5e709a53b0"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e74b8d8039a32357066e4887048c907859e458d46627ffb14fe07da0b9a61b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e31f4ae2ca34dd47912e54975455dabf1bbadf4f7bb13bd3f41ce1f65315605"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7c8560d8b4137bd6d8f6cffada092d7e628f953a3de93b24db2aef9733f871c"
    sha256 cellar: :any_skip_relocation, ventura:        "b09347c0d07a9ffc2f1b21a36cf797570e73c13f94f217a073d7a17392654526"
    sha256 cellar: :any_skip_relocation, monterey:       "85da3b37af4555c7ff57d9eea1a4825ba21e0de689383dd11763bafa864f9605"
    sha256 cellar: :any_skip_relocation, big_sur:        "23d063bbd40867bfce15a154f218fc0d6e4c5228d44f6b911429eb41009f8dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a391656ce74dcdd2f75edf7b171be50e9c0097df70ca420e19bd5154bcf66b"
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
