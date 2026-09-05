class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "d91fc2f4cd04998a16b92cf58d29bfc94272fff39a78701b32223a05e1e89b68"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f56c64e59e89e7517f5dcef0ef5ad30df22e84b6359d289e77f191f4d2a3a4c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e089b00dac6fc14bf92d1e3c69df916c223d0084059f108d7fb145ff951a2eff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ee829c5056a789862e57fc72e488d6b00be1d93fc95f5cd2d91590575dd2115"
    sha256 cellar: :any,                 arm64_linux:   "b03f965ad07c7eef5aece3492a7cf53fc446d8f31cb7d7e71ac84ffc9562546b"
    sha256 cellar: :any,                 x86_64_linux:  "591669906ceacab6cf471605e5b242cbad0758eb95e900becb4b5919c04592c5"
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
