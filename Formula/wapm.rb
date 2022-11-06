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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ba1bf4b8c151f1005acf4429b6b951a786d8727dead1b86edc72993268520cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "767f95eae3e10dd0386d7f839ce1f6aa509e3e10c3d539a9f69bffff7c3e5bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b9881207fcef7665c3e9946d76494f4ee69b4472377955fbfa3c80dd5c0e329"
    sha256 cellar: :any_skip_relocation, monterey:       "5453c51d197c085d3011dcce5c2246a67546ce16be0395eac6e83b9766350fae"
    sha256 cellar: :any_skip_relocation, big_sur:        "38f2fbee5a31075c015af4ccae015373fff9d98d7c2f3c98c954aa4372732ada"
    sha256 cellar: :any_skip_relocation, catalina:       "741ed8e6ac14facdb8af1f45131f41a0e32d94b1a960fe30f82053ea1697d6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b401e546148144a0c1f98dd792683535790a13a1ff7548d9cff2c40535c5d43c"
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
