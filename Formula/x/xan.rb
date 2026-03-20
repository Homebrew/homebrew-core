class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.56.0.tar.gz"
  sha256 "9c206eee75bdef1c249528fc22216611a76e6450c883c566efa24b6a5b17d43d"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e9665dd3e9ef0bb14a29948041edb024d7ed9a9d923160297a9ce923933f89e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f2de1cb68f2797be169c1bebc22a73d2ce048904f3ebe44776b7d0c03ab5d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86b986095709546e46fc10cd44e48fb9e1614f0c0979214a6d446ed30d7bc51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4f581c3f1763e36136752755872795ee11e7867bd95b625af94a3963911d166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65ccc76fcf708c3dbee9d26f8cc4fc536097cf04dd7fefd55cde27ee39aea692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a45526acd1f6f6a9a749c246b962325d48491cdf22e61bc76a79a5c1d8f3ca1"
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
