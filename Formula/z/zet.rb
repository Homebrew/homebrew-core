class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a6f431927c16b22516e78a9ec7864d99e2676abae3acb46101df1c287e16f267"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969859a7af56ff259df9c72e15a45dc0fb7ac11a7e0d70264a5f14dcf9efe80f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ee895f1a866c5279689ea67039f268f036126cdaa95fce89ef694c67c9d469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaf4041c27353f5278d0b7f232040a91cd8d87e9a6eb0d6dd6417186f3ab121d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b42203cb1f07a7f436b7c6ba9a98667ca1e55dd65157fe8fb445a3de4b3c9e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f7359f71bb633a4dca674758356c976b74cb8c9b0a78d705c07d33cbd157414"
    sha256 cellar: :any_skip_relocation, ventura:       "7155960676e9ea9a1e323e80cf7dd1191a63951c097d1339d179873218519677"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72716b50cfa1d1d51899f91f61ddf848b6f164e93082f2300a9088ef463921db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85c0892b0c2723950c55e1df613854ef10c21b708392084176ab0917c8a0ba7c"
  end

  depends_on "rust" => :build

  # Backport fix for newer Rust
  patch do
    url "https://github.com/yarrow/zet/commit/7aba3b6016ede0b0a6b8aaff292bd7f6a0d7ac86.patch?full_index=1"
    sha256 "9fca853d07ac5a81aafe8513b64ce1ef338f1ff106d7ad2eb16add777ba2e897"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    assert_equal "3\n5\n", shell_output("#{bin}/zet diff foo.txt bar.txt")
  end
end
