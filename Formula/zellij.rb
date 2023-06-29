class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.37.2.tar.gz"
  sha256 "1f22223f251dbd352479d4671c0c742ffa225420667e20711d5515be2eb2a256"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2994581dca8a6c130d28fde782e36d2d07b8542f469856ef2eedbd1cbc133ce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f4539833fee676996cac5304fdfaac4817bbf154775424a912efbf68a0a892"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca3c9af5c8769ce0a0dd8ba2d1936c19eeeb5b8301baa514a8568fc4500acf07"
    sha256 cellar: :any_skip_relocation, ventura:        "24c0ed1430e739b11ce456e7fd06eb90d2c011e36905513d6d514057057bd092"
    sha256 cellar: :any_skip_relocation, monterey:       "d1a7e40ed2c27993c3b66c36663fb836401df41bdfca5b217f27450e3a9052ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc1568641734accb67db43a2b428c4369e0a164783fb9d3323b42629a2d6dd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48f45e699222ef55823a1d1c2854b7a49ad0dccc2ca7c5b8fa7e663381c58101"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
