class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.6.tar.gz"
  sha256 "8230a49ca2d610f55b9104bb292d11a4ebcf09d6118dbf8615a06126352f117b"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ae9f17921580b58bd21ddb03fa55d5727c76d414b3625577eb175fd645c6925"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d266172783b37eaef3b379894acbcefd806fa242bb225483001491c37bbce4bb"
    sha256 cellar: :any_skip_relocation, monterey:       "b500295f120bfb4c77920e76a22914c3a067bf9840a4cbd81ffaf9f1b38b496e"
    sha256 cellar: :any_skip_relocation, big_sur:        "77042210be915f81ea9faf9bcd2816d62e6ce21bce8abd6ae7be22d247d4023a"
    sha256 cellar: :any_skip_relocation, catalina:       "7fdd3ae7c6b9a6f1733abc0dd6f553c57f2b4012ea72c39cfef3f42e617718d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0136e23de57e9f78f0d8fe29bc1e8c6421a09ab6aece1f02056ec29f4652e1"
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
