class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "841c75ae2618581d8c034a31a2ba0f9af3219b40bea551fe157cb42028b9ede0"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80375e0acd0171ffebd8b6b3858c66a893b2ef03a5a4ace11247b68dfa9e026c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce58bff63f3a99bdd800c2cd332384a8592fc3e568f264874239a7594a64b8bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29dea4f203b8a2e8ead7fff22d8d8eb8a0f5e92c1369aeb639340dbb0cc2fe42"
    sha256 cellar: :any_skip_relocation, sonoma:         "be27df9d5e8aeb394579363a07cc5dd1b79aee34c2db1da481fffa08625a04cb"
    sha256 cellar: :any_skip_relocation, ventura:        "3efd87993da388ac89bbf1342a0628f0351b5c4a3086e37eee720434ce10da46"
    sha256 cellar: :any_skip_relocation, monterey:       "3697ed6a5433926a5749c563c0c5f60e30a8d6020032643fbecae9fdcbd8ba9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13016b92d2ca9c20cb26200ec2f2e1478dedd917807fc7c45e35ceb4e18ef1aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scarb")
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
  end
end
