class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.0.tar.gz"
  sha256 "7731d476585105fbb0ac5766661b4b68f1680b7071635654042bdaeef3b66987"
  head "https://github.com/wasmerio/wapm-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15d984bd969f4d207549ae6c51f2ba34d945c4b18f8acf0ba0c001dc54fb9039" => :catalina
    sha256 "b5be8c6e0592ef6a7133afbb6e9bbb97e62d7eadc36a2e97b505179dd6c35f85" => :mojave
    sha256 "b0228e63f09a647ebf5942adbfe32e82323eb9c20eb04d333f01ed7f18ffbe28" => :high_sierra
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
