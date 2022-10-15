class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.11.0.tar.gz"
  sha256 "7b408ef8a2ab47d7a7d0e120889bf12c8f2a965796f8a027d8b2176287fdec6b"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf006c8cd8eb931dc8f5ce982912fa66aef51fbeddf4bb7e11e49b66c9b2c7c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e3bdc975e9fee1de10a032438759744e1f7f3e1dedfb2f8b4e73d290936b2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "2cea5a5b331be5f0f88c70ba70149bfe5a3a03152eb989d240b87f8546fbccaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "95794f8bf3644c959db217b702ed22cce6e11bb6ca9cd3440045c3159a96f4ce"
    sha256 cellar: :any_skip_relocation, catalina:       "b8278a50780b041e461d731ee6bcfe3ed03dff84516c8b34fbb1294f1907cfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30b5f36caca039447669830365f52f0779074fcff564189bbde908235b908187"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
