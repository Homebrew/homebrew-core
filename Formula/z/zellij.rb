class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "afb15afce6e37f850aff28a3a6b08abd78ef26a1c9fa3ed39426ef0853154438"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5cfa780e9961a12a40ef0ef61444191caaa647107a2de64ef07f69208b21a9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "923b982956dd8f121e1890b4ffc9b74d8664239afc8a35340d9c47dbf35badbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b95a068110089e752c072fe69faa6a695065b5f0caa6224d1a261530c8e33d"
    sha256 cellar: :any_skip_relocation, sonoma:         "67af8eae9d7654516ed745e3f6f5b755e330f336f821b9f78640ade04bc36c50"
    sha256 cellar: :any_skip_relocation, ventura:        "4157b6e39ba2082ebdbde2e618d2b3b83a19035f09ea39d68e34bbceb44dce89"
    sha256 cellar: :any_skip_relocation, monterey:       "0822e08fd06aebadb95c96340d455ab43c81a47d58b92d0ef0e0f5fe963f5ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db109cc2e706ce397f844850c8ddcb335e5626277bf2d9615d9ac5e95786303"
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
