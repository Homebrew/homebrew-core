class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "36d8bc53b9c05e242fd4c9ba8ae447fae6c4a35d8c7e071f8994a7c0f07c225d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d106bc00111838ead6bb1875827882b2b38271384a2b5d486163f8ec355be0a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "82b3ba2bd29430167b84cbc7116ca22c70679e0c6a59b340c3349ead364c0e16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c26864040cdb083f702827d253cc9128d018f12eeeff0d4477908385c38eda3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e83c51f58acc449889bb035f202e9f0e9a4fe5b498c480c2a58e0982b93a820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ade232aa606461f6c6a8fd543f6d9048d52f8931d4ecb952d323ea5cfcc63bd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffb713476e09d5bc6930cc1b550efd65d9556103f6641e2f2ca8bd9a8d9c374f"
    sha256 cellar: :any_skip_relocation, ventura:        "e80a401d20434c2716eb29d1a3b80ff9647ea7b00e6797a8d35b260e4f7cf6c8"
    sha256 cellar: :any_skip_relocation, monterey:       "72daa345f044b21902150324f5b8240d5625c96ae25a46f4696374da30965567"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a1477dceb51ed2cb6ba94b4f5755376fdaebcfe22b7301273120dede98403ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff017b24e8061f4c5ea8b37e9f675d636449f6206735d130dcde4db047729b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # try a query
    opts = "--search-engine stackexchange --limit 1 --lucky"
    query = "how do I exit Vim"
    env_vars = "LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm"
    input, _, wait_thr = Open3.popen2 "script -q /dev/null"
    input.puts "stty rows 80 cols 130"
    input.puts "env #{env_vars} #{bin}/so #{opts} #{query} 2>&1 > output"
    sleep 3

    # quit
    input.puts "q"
    sleep 2
    input.close

    # make sure it's the correct answer
    assert_match ":wq", File.read("output")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
