class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.1.tar.gz"
  sha256 "e01dcf040cfa32cfcd1ad7aa18a0cb40a7b8040fb34a58de8ebce2c47ad154a5"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bda35860a53c4bdd4236cc268b5a634c99953d10425c315f81ff98c744d95db8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a669b38d7f9d849aea1a16ec1b2b93a3d10cb8d7d64b98e2e89ee774bab23acc"
    sha256 cellar: :any_skip_relocation, monterey:       "bf8c504485e1ba2397bbb51773f197f0e48366e7d9206bb8b8f8cf94ddcb0faf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef83086768af8348415cc720b3b4241d20cc7b1c00946d6b4f09ecb4c8242e19"
    sha256 cellar: :any_skip_relocation, catalina:       "b9cecfbe7298d07700898408a94862c6caf0aa69e18322e404df87d0172001d5"
    sha256 cellar: :any_skip_relocation, mojave:         "15070099aa602582bcc3d701a1a6626f9f17bfce559ffab53c4a62eebcc2f170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "005d9339f8a52dae6524b6b94fbef2a0d5032dca3bd6cd85d8963c0ed7943d75"
  end

  depends_on "rust" => :build
  depends_on "wasmer" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["WASMER_DIR"] = ".wasmer"
    ENV["WASMER_CACHE_DIR"] = "#{ENV["WASMER_DIR"]}/cache"
    Dir.mkdir ENV["WASMER_DIR"]
    Dir.mkdir ENV["WASMER_CACHE_DIR"]

    system bin/"wapm", "install", "cowsay"

    expected_output = <<~'EOF'
       _____________
      < hello wapm! >
       -------------
              \   ^__^
               \  (oo)\_______
                  (__)\       )\/\
                     ||----w |
                      ||     ||
    EOF
    assert_equal expected_output, shell_output("#{bin}/wapm run cowsay hello wapm!")

    system "#{bin}/wapm", "uninstall", "cowsay"
  end
end
