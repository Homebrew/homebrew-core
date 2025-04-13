class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.48.0.tar.gz"
  sha256 "6b59b653b36a42c57a24eea48a977a0302d6e03e11058996cb3ec86fc6f3405f"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad844cc262924b5f022a115be18ec915ecf196df050d78fa121cb31b4442136a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2536645ab52b343fc2569ad6c86fc52df82e2e2f88ad7f53eff3e46175f0aa22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "102c0c4cb05925b841f887fd39f21d7d8020959f3a60af0b4aabe5dae99e2221"
    sha256 cellar: :any_skip_relocation, sonoma:        "88c34d08b362ebc6fe808d9be172d9248deb0625cd94e342ff313117672f237f"
    sha256 cellar: :any_skip_relocation, ventura:       "8f7c40319fc7330631a56ce047cfb7b45c6899d31c14ec02041365633eea17aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae5323b57b8ce18dec05a6ddac7e96ad873976e14956a086714d3f578de9223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0330b88e645b2e872dda49ea0b5344a8a0b0089b41c471ae8edafacc4c15f33"
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
