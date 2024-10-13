class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.13.4.tar.gz"
  sha256 "f6a1e89e4824d98319ec46722c05f1e62434543875ff3667732c161a0807ae20"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d2be670667a6dc6126d1d8ed11838fd08410454012b33d753b5303d0707edeb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "137ef65d7d822c2ed57bff8bc098ab11168c925d8198918f87b1fa93a376d362"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "336b0e074f43614610e54d207985063f9fe0a1440df2bf482efef46de51da3a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17027733a8674785f55c44a21d2485ffb4d6ec6ef22c77868afad0094ce816bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5938be9883cd38e142b464027dd8f8b28373544e815220131c9b3591e7e45369"
    sha256 cellar: :any_skip_relocation, ventura:        "52b9a187f6b9b775b7eba9844bf7fe9630e333e3dfb59393f588bb91997aa470"
    sha256 cellar: :any_skip_relocation, monterey:       "80c71954d4cb1d1fb5f6b2e629d1dedda3692499cae1f42feb5865db1a210b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69183574c6b982ee2514f426b7d3c09e35e0fbdff198e6f9bf546a37d1197ba2"
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
