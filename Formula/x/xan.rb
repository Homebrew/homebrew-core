class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.49.3.tar.gz"
  sha256 "1eb6cd5ae98c68ab6c1456213b096647ef0bdf15140e67f3b16950948e5e1d19"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b65b7d54cd7e40cc1245060eff58498dc99fda288bc4e9e01f4c0fbb9b010c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ab68727d6240ebd3ec191b9e6dd2ff24235d43f2ad632a8cc2339782e0d961"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f2b3ad791b22acc5cb5397fec715bebfd3ff03ed2d4202c9e603e368d08524c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1956a26a84bb5713eb1218f6f8e9642ddcf1d7835f6f500b011ae2445abb84ec"
    sha256 cellar: :any_skip_relocation, ventura:       "fd88d15d4f1943ec8412591964940ecd1b74e5fae6b3e819b93444c6dcb8ac2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91200f9e59d5e2db1a74889be643344baac32664622c50d6103dc080502af471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "319abd5ffe3768f8e4d0b5f3a47d7d63f86a4b94a072daf250b6fa65cdea675f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
