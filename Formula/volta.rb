class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
    :revision => "a8186ceb9c0c015730d81054894a5a3690403d7a",
    :tag      => "v0.8.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "78a293f90dcce1e7f356efea490af6afdca1234627bd66af90c66a7af4fe2d53" => :catalina
    sha256 "7468da511debfc4a7bc1138086971df9890c241affc5678bfd9e06149801edf1" => :mojave
    sha256 "482b0e1808cad21b044066081d278c561f4952ab0c3b5c8c9cbdfcb8044e654d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
