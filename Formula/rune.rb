class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https://rune-rs.github.io"
  url "https://github.com/rune-rs/rune/archive/refs/tags/0.12.0.tar.gz"
  sha256 "7683526f9f9259f4a7fd33c4dda19fdff11850eccac5bbced89e9bdbfe8aeb38"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rune-rs/rune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4609c4f7b0e77cac118f3df2e9b59f1eb364c182cc3d564ac0d50f36a4f7e6c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d058db7728257b6a4438f56edec20eef25c14824b01e88bf18ba46d0c08a860a"
    sha256 cellar: :any_skip_relocation, monterey:       "495574ddafd177562d02676690a7aab661a85e452a5ff1fd65525e39ce578a78"
    sha256 cellar: :any_skip_relocation, big_sur:        "92d02e131eb33b281e5bd6b5901895a9f55caa8b2bb9cfb6bcaf23be49f111bd"
    sha256 cellar: :any_skip_relocation, catalina:       "45090c9dcd9c35948965bc68e057b99f19065b0c6342b9a1b3f06fad8c2f33e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac7c88aee69843a328875a16058e824a7a18ee9a02ab55ef24281fffc6ac1df"
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
