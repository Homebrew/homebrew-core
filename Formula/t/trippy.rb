class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.9.0.tar.gz"
  sha256 "bebd130c74ceacf4bc6b6f3aa92fa639e1904eb904c5135f53c45510370289ed"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb73a1170eb0df6ad758e22ddbab988660b051d11981458a9f0d635186e1dad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91361032e0686bd067dab5a091f79eba270508d8d9da114a20c07c77a7006e87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906d4750087f17b06fe4e60eba1647f5f09231520561d37f0f64118b25f38178"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bcb3fd0dbe583d6b444921353e2039c8ee45d56c0f95b605466e61e022c1bd5"
    sha256 cellar: :any_skip_relocation, ventura:        "a608dc82289e638defa28cd6bd8d6be081e453cec02fea2fb45cb07269aa4640"
    sha256 cellar: :any_skip_relocation, monterey:       "2e5f71ce5c70cfc52569c0aae1cbd6796813661cfa5e2388f3c3b077d76ad81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a02ccc325a2bcbceee089a91ab909ec30c4a25820e7d854c2f53fd544e4f8a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}/trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}/trip --version")
  end
end
