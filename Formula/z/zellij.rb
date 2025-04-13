class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "e9516879483c1bb617a13e6278878883943c05f87bdc41fc02cc550a7b06c0b4"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3e5f90d5b03df1ce25975775149d37a71dc45eb2c8add0d3753a2cb10dfcdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55872fc7255f9d07556a51668abff3de285b731e7d623a49b17af52942523876"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74296e4cfd4f587a6d510f0ac4f85550bb4462dcd4116c81ac45aefb3d403dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef168ad14b66d374faa6b8b578811ce2005184ff0fee29a1501a928fa2bce382"
    sha256 cellar: :any_skip_relocation, ventura:       "7fa03010a491cb9059abb9d1213562ecc35bdcf3b59d0991cddb84f41c5f499b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ee394841f67002aab90ad258a8a3a77c3e0b33f1685013053c8f5b9337a11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa7482e5fa44b9816c71a52aeef26421a621999b16e24dd7034faa920790aed"
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
