class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "d863b77332bd56cd37a45a99ae2be50a9aa332b66b523a4a76676bd778c017d4"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f748755d4a4c0277c031a003313e3378b5f5843fd63894f4cac48ad2ccfc895f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4609c5d957310f17e21484a96ca16d49ed85feffd0a329b41964e4f330630c7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b31f6f969286b5c857cf0bdcd5f7ca4ba054e2bc70758f8e353bb748be5098a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a533562753eecf7d94e5076f5ecfd01399311e41c755461d10885dba7a7c62e"
    sha256 cellar: :any_skip_relocation, ventura:        "210ac04d44cf0b35686bd0890a9f78e677478abb67abe88b3589a0a1949f9e45"
    sha256 cellar: :any_skip_relocation, monterey:       "a929b332af250976fea9af4855799b57fc4ee49012bd65eeb52d59aab957b90b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f166fc7a9743eb8797d9322b2eb9213e716d6b64abce21b8fb7bd31582d6527"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end
