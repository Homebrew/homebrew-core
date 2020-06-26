class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.3.1.tar.gz"
  sha256 "3d7a7784ed85dd5301f350a3d05eca839f24846997eb0a44b749467f0f4dd032"
  head "https://github.com/dduan/tre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eea4f9721693b8a53653493a5f23ba5c479408f93af5b523c0b1c2a735e8221a" => :catalina
    sha256 "5cc06505dea4282bf314af76b1e4b4fd0157c837c984ce579251cd65d53a0623" => :mojave
    sha256 "b5732a5671204ef476c21bded3722d2f72227dcd9da6582185b316dee6fab97b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
