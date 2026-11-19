class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "e0d3fd22e464475577e5de9c4bddc8c56ae23a15ece705b94ef883b11909641c"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e019b16a6cc258d370d453f74062acd0832ec55cc98d0833e6e4e36f63810297"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1c7f9d991d6e8190a3cd3ce69fd4e97cd1fdfac5a1aafc96c7e2e13f2e7fae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94e21d109513658d58895007ffc7fd15fa9d8a41b01a895311594181ed880ce4"
    sha256 cellar: :any,                 arm64_linux:       "53fadab626d390db52af45458e21e124376acf11f441e98c78cb2f5d07d664c3"
    sha256 cellar: :any,                 x86_64_linux:      "e0e8964dce1a7bdcda8838f7bbf83719c151e25fd291c7e6b9b6d9714fc6be69"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tgrep-cli")
  end

  test do
    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("hello trigram");
      }
    RUST
    (testpath/"src/lib.rs").write <<~RUST
      pub fn helper() -> u32 { 42 }
    RUST
    (testpath/"notes.txt").write "nothing to see here\n"

    system bin/"tgrep", "index", testpath

    matches = shell_output("#{bin}/tgrep 'hello trigram' #{testpath}")
    assert_match "src/main.rs", matches
    assert_match "hello trigram", matches

    assert_match version.to_s, shell_output("#{bin}/tgrep --version")
  end
end
