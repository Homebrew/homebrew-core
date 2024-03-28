class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.13.2.tar.gz"
  sha256 "ae082dc218092d9ff67587d59035ad250350d3f7cbad5b7390241aedfa93d22e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59281f74a7559cda69f42492fe1bce1ae7230bace893edf834c67265ac9412fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c0de05eeef2a1a24841dd3964d1933a69083dbf9fd5e5220e0ea0491ad510b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa9f62d32549c6506142fbd0e505b40b9e65e416c36f398d880fed05d5c095a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ced2ce46ef5355f4d4271c999180e3a3b3e3f22451421a6821d18b97059ade7"
    sha256 cellar: :any_skip_relocation, ventura:        "86e7a6bf07520f49820413991ff84c9e1163ad32ba5cee29cd031d8746c41698"
    sha256 cellar: :any_skip_relocation, monterey:       "ca1b65154871cf49c5d581bd1120ad992698bf08c7c3f1c00c6be192dc2c58fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "758823277fd63c8f94e23e9a407f7da25d71f34e3db9ae05d54a1c7857a32be1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rune-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/rune-languageserver")
  end

  test do
    (testpath/"hello.rn").write <<~EOS
      pub fn main() {
        println!("Hello, world!");
      }
    EOS
    assert_match "Hello, world!", shell_output("#{bin/"rune"} run #{testpath/"hello.rn"}").strip
  end
end
