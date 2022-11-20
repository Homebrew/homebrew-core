class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.12.0.tar.gz"
  sha256 "7683526f9f9259f4a7fd33c4dda19fdff11850eccac5bbced89e9bdbfe8aeb38"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12b623175e597bdcd6bdfa40e47daaa6d30ed47615a5cf10ac4caf21ecade611"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead15808a4e9a028f9f0c792a8da3472b9dca5c28caa815db11b870967f71fc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37c8cf2ca8475684362479cb7e1287463c339eb42367948908f7c1b3951ee783"
    sha256 cellar: :any_skip_relocation, monterey:       "5b0474ec5f77af2c8677593c89200a6e55dfbbc11c8aeb6e2c9bd244ea313803"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b39b0c60660ac9923edcbb136c622262f8580242e4f290892a6e563bfbe599c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef7af62525bb7609d09dafe2bddb5270686e7d7352ff1c1949ac5168312bf267"
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
