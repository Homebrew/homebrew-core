class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.0.tar.gz"
  sha256 "7731d476585105fbb0ac5766661b4b68f1680b7071635654042bdaeef3b66987"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "0486738558d41ea02a4798cf54538942d1fd4f292ff230cd522f51d27b91e376"
    sha256 cellar: :any_skip_relocation, catalina:    "4f1c18ce08a6f4a483a50888ad9769898a203bd826b992f877010f38a80ca710"
    sha256 cellar: :any_skip_relocation, mojave:      "db34bd4d679207ae7d903a4beada8e30e3568f16c55fd610a196931c440716ef"
    sha256 cellar: :any_skip_relocation, high_sierra: "70e4c8f038838547a2e70116567c1042f2f4cec53542e0750d4d061f80dc7b23"
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

    system "#{bin}/wapm", "install", "cowsay"

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
