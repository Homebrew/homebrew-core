class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "f1cd4b36775dd367b839e394b54e91042b0cd0f2b9e0901b1dec8517ff3929c0"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d6723fdc5f786f2a6fc97ffff21e273cd939dee49830fc0e9f3bd644a68cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19da49780d4ab34349ae6641178e229a7a6660f38fb240dc1d751e0ec6055b41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc749a1d8c484f18371c74a90d3825b1f53f9bca69e720cb8e06c403b236fda0"
    sha256 cellar: :any_skip_relocation, sonoma:        "28e648b3ca2243a6aacfd6ae0d02aec5f4f66dc0504005dc51f5af1a79f08ba6"
    sha256 cellar: :any_skip_relocation, ventura:       "54d007762dc1c2b9651aff9813639d8a11e92615b8a26be7dc40dc7433400bac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee15261c12d5733822abb5517f2f647a71668312b700e1795327f7aa487d8aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d652caa249158b93d8fb1120161808b537639f5a14733c72c4af68c6ac456115"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
