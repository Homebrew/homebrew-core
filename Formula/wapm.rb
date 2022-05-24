class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.4.tar.gz"
  sha256 "783e1187dbcc78021180c1f7d35ea7d165415b736488c72c9ff6ea390d3c4de0"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f9317de931934fd7f162b6a359edb28a89ca85f8d1aba713a51e9df717f4645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1397a70ed0a3ba24920014ce59573f4aa0475e66125615a3fd5efd57cf8492"
    sha256 cellar: :any_skip_relocation, monterey:       "76421b76f33bf57add17cb62072fec9963610d4b4a95625f37b741dc6267d619"
    sha256 cellar: :any_skip_relocation, big_sur:        "93665738e27a68c4d59244b111bed071ede27ab4e93d1dfed352ac64d2089c23"
    sha256 cellar: :any_skip_relocation, catalina:       "b6af98436de52f5d3ce7275c2cd5c1a5781dfde99197f5faf11ceed6d553d247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e7311ec4d57ef19ace21e3a4e744444228f91acf1d981242bf40763c1e289d"
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
