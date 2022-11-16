class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.9.tar.gz"
  sha256 "67f98e7e584ee05b53a70e19624ca73538aef28f46e1bb31c49262ba0e00a2ec"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cd47f3b1bc248b7c623f6b8c389f8f5ee679d3f7f26c49695b27c03b989e864"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a8878ae54cbd3f34670880ebc789b2d1ace4005fb9cd86a8a1247e7a5806049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3e524ef943bc95c1d6913695348bff809cfa465ed173482122ec33cf7a780c8"
    sha256 cellar: :any_skip_relocation, monterey:       "76a8bda1a40a8bab8ce122715def649792870ec15a72b8066db69ba909a0b29e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd7be35193d065ccf309726d220105ee9da0c3b57fef92b9a4b8d6fd40a587fd"
    sha256 cellar: :any_skip_relocation, catalina:       "00589cb835a62aa7764993390f69707413d0260a20a0d0a7b7974fb37b6a8e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c671976c09ab460c6c878b73cc2f7a117d41a008b29be53ea20e83b36380e1d"
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
