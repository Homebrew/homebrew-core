class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.70.0.crate"
  sha256 "c7247f644102118bf9326c7be10fc800fedbf3db97faec924527619a2f26f900"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef6a6721db6bdb8fc8c115a57a9896ad4967003c8103ddae57147866983481a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bcd495b4b99549f39d768168c96be5201acab5d9290c30fd63f84b82eefb173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49ece1281021293ba2fe424f5d1c829059e7ca24c68e7782e4b28ae7a1d9b9f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8cda495c4e618a88bdd82dae2782608a741153580ef6d80cdbf7653c2a47177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99afdd418e86942531746ba6b07da61c3f40827dfa67d92894a33ef493146b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6187303a76066ef8f163748c5f347e8961d8e32bd123d327c858da10cb1d7294"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
