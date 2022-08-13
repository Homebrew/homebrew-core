class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.5.tar.gz"
  sha256 "145b91406b55671a88bb238bf8545d9e354da1a7e82fba7739b81fffaabd7d88"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a093b63c39b9c617108856c98451f34ba169c23e36d168a702069781752caaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0680cb4ab9b5d07b73171cf9b4576f489c078dfad56badfba4842a2cd9eb693f"
    sha256 cellar: :any_skip_relocation, monterey:       "93cd7e9fc3a35b92d6a207d4b76626d25ea8813090d8b359da5f2be0bd3bfa0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a2a7059be7e50ef39edb720ef6dfc092ec75566ea2212f170d4f44402cde5d5"
    sha256 cellar: :any_skip_relocation, catalina:       "a42c89ed41ca92935a82eaeb540656a2b5acce62ce6cc43658fc17d92734eb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fc66f518f82bb2272b35d8c5cb4fdff6b8d2520c7f332f124a403001991194"
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
