class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.0.tar.gz"
  sha256 "7731d476585105fbb0ac5766661b4b68f1680b7071635654042bdaeef3b66987"
  head "https://github.com/wasmerio/wapm-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f1c18ce08a6f4a483a50888ad9769898a203bd826b992f877010f38a80ca710" => :catalina
    sha256 "db34bd4d679207ae7d903a4beada8e30e3568f16c55fd610a196931c440716ef" => :mojave
    sha256 "70e4c8f038838547a2e70116567c1042f2f4cec53542e0750d4d061f80dc7b23" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "wasmer" => :test

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
