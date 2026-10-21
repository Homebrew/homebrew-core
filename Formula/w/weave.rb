class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "686a52cbbb72461c8ab36ae15686dfa74fcf2f22c47decb6afa19b4247f58460"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "643d09cdd86e1a2f7497e45d29bbf30712b884382cf289d699ff69a8f85c390f"
    sha256 cellar: :any, arm64_tahoe:       "b8c59808004340605da360a33501920e5b770f5a80eff8d75ba9c876f90d1ccc"
    sha256 cellar: :any, arm64_sequoia:     "9bbaef582634fb080d66816e3a09ff375f3f3326429d50cf7a241c3a5352dab3"
    sha256 cellar: :any, arm64_linux:       "eabc146a47d1f7d4015748fa6261e778201670f91c40ddb90ac648ddc6b09384"
    sha256 cellar: :any, x86_64_linux:      "8fafa0d4fc9a416169afb6954fba423071f54719971a87622b46c10d63fad2f0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "texlive", because: "both install a `weave` binary"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-mcp")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end
