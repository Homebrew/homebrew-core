class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "bec89a1a833661a367fb26fc68730a9324ed8f58b7ad4f78f195250c77753938"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6524a1d13a476e5cb66e1b09869d28c0487fa6a15c4d3a61c32092e6ae21aea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b45e9ab51d4658661745daccd93902d4cce9c93c501441b07cd012677cdcdec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8851f5436bc4f44d61247a6da79621fb74bef75af6fa20032ea60756c9422856"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d88a92738f81f0c1e20de34a15b77eb2b682711c42e98ec43d433a98ae5928b"
    sha256 cellar: :any_skip_relocation, ventura:        "5274334521423133bfad3017807241ba47edb24937ae4b00a9314be211028492"
    sha256 cellar: :any_skip_relocation, monterey:       "d10ae097d53ee82dc25f878a2f424ec04ed91c7dcba80613d918e79197f665c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682ad26cd37857f301e17d920dc84e48c1c25be1d37a5a91663c422e7d365e83"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb snforge-test-collector --version")
  end
end
