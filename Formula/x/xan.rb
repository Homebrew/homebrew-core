class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.54.0.tar.gz"
  sha256 "15b024631f72f789bfe22694a8a1a09a6411a6ce31bac0fc35f2e4db0d4d6362"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "513daa6e7bf00e1e96fce1da9228c49a2bf1297842ea4339476d20710ed4cfad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d23048eb02828316e546014b6813f03e5a8081f3cc18886a15c02aaee8c2c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeccbd0fd93c04931f86ef09096d1c718cd59c8aac6133d114929b67865bbdfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "62382ac51ba047f92374f1ba38cb13421ce19788da6b24cfcee49c645a76734a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "744ce8485e11cf9f0023189770916743a8b268660c9e5b3df44e2385d34429f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c477d0e65629a7d5fef233607ae7fc216c5272b1e686724f783052031cbdbe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
