class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "4cc03fcf8eb2bd6b3fcb5ebb8c26fcbb9fbb920985231eda51b950721e4ce8cb"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    manifest_sha256 "c4aee7dd16db846a43296f9ed2d4733b21082d204b0dbb7706699e4c6d284a8b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ba87905d005f63d42c12d1df70fa730d9a7223c74bf1009ff761b8b1a24790e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38e2a0b374a5a9ac4331427358ef271ad6988048d202a4980a6467396ba6f7d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff76ef68aaa8795c4135a93075f966df8e6dbe64d32ca2bb0c52c194617423de"
    sha256 cellar: :any,                 arm64_linux:       "c4f4904abc779d64743a1e11f8fcfaa85899686d370443f629fc5ca513cbc880"
    sha256 cellar: :any,                 x86_64_linux:      "db9ad1d30be43236e09896f9d88ea9918518ec28e3abfc887ccf7df324bcd5a1"
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
