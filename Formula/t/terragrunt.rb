class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.12.tar.gz"
  sha256 "c5f34153c52817fb73a5b2fd4d6db6b4f316b76bf54992ef9b7d8ef28d6fd681"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0df08c60a54f93153570f85f059e177d2582d066def1c7539c61ba3847b98ec3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20864bb36422abe53622e0c1be6bd77e59d4a6dc20d143fe35e99727a3d5ab83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5733b148410587c2b91c053737680f84f98185512291634df2e7405875d5541d"
    sha256 cellar: :any_skip_relocation, sonoma:         "eca36c23ce475e75c9add09998d53cd3187fa71905f70457da041ebc7d01de41"
    sha256 cellar: :any_skip_relocation, ventura:        "59d3331d25a968795b28e6d375d11e9065a44b716e1ea0e6cfd72caae7b9f3ce"
    sha256 cellar: :any_skip_relocation, monterey:       "6a48a60fdc41ffc29fe65abcbbd6f6a2b01ebcb42b1a68bef2a91e186fdb6638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6416a2538d963c0dde784bb4189740c04dcef4049889d94679a2aeccb5b10bc"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
