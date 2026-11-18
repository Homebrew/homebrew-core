class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.75.0.tar.gz"
  sha256 "7a9775338cfc6965a770ee9af18f3309b92d7591e6744c8d0f3e766c5d68a8d9"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51419493218f40f9a02daa77d5e0a7fd6032c3fe34edefe207cc42f8024fb3fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "803cbe8b4db9a5fc0ee8d18762289f950b8545e7bf358dc5a1ba0911c2c26592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37b61a26aa88c763af324b926231d04b4b8758cb1dbf783e4555c250818398a6"
    sha256 cellar: :any,                 arm64_linux:       "c1fa927a1ac3086e6abfecb40dc1815deb1f3e98693f565a63e68cccc829ce8e"
    sha256 cellar: :any,                 x86_64_linux:      "076c3857c6a29b9fd77ce8b9cc3aadb6ad4df1098428642a4bb587c51bdd87a9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
