class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.7",
      revision: "b7ed23325d2825143471962cf94b722e1305e615"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd2a2900d4c3378471fc9af3937c2a2d2c193d053746c6f161d21dcba6b5236"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e0b710ec8670028919a716d7e71e0487248d318aaed2badf85cf9767e8648d"
    sha256 cellar: :any_skip_relocation, monterey:       "2dc96b13b56511f5c5783612ccae0a7fd709935d8fb609b1b4a622cfcae1c4b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4227315745d14339d2e8e47c095e67ea635e09737d709073e8c48dee0621ef3"
    sha256 cellar: :any_skip_relocation, catalina:       "37dc03ed643e31211b497c658f2f2378db09db52f336bbf41d1a3c8b876ab3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a99343ba6983fae8aa7db38702d9ba6c17ef1d9c99b2b677d1be2a6fe530b2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/volta", "completions", "bash")
    (bash_completion/"volta").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/volta", "completions", "zsh")
    (zsh_completion/"_volta").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/volta", "completions", "fish")
    (fish_completion/"volta.fish").write fish_output
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
