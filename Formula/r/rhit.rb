class Rhit < Formula
  desc "Nginx log explorer"
  homepage "https://dystroy.org/rhit/"
  url "https://github.com/Canop/rhit/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "a3f45fcc2c07c9a7251ee6e8dd631cf12d4b506e63cebe05b38cc549f58937d6"
  license "MIT"
  head "https://github.com/Canop/rhit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eefe72eba81f5df0c61a9bd1882dc2bff2af473a591bd8c35eab0ea00bff40d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d35ab9a4feb045988b0a4674d5eff78cb9391d6f13e401e3a572335d9ac8a2e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ece0f944acf5198d2a8558a8eb2f4fb9808835e5d0db37e5c2532a168d0ddc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4764df4672c1d9f7f329beed7ab7891c150a8a93e003df43c2f3275ebcbc7d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f1a862f4e55cff0d2b4ca8c77e53e0f064d2fcf78a9e1f07296a0cd3b1374ca"
    sha256 cellar: :any_skip_relocation, ventura:       "77022fe12a1bb7e2a6c035218f55d4bd6930871fb60e72d94d4f109d460643c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfd5b75ef16987d7ce67a99e59375b55024d739871ca5b4dd900fd0e966d1cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39a1dd27646aebe1267cee8eb08ff5fdae2038912685c0bf670005335a24b054"
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
