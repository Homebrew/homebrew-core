class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "e839bde2fd94e2c71d6c4492f09257f864369cfa355f458556c7be06af165327"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2125c3f71a44e00dab3b183f88fd3fddf663ae2cecc418c289b8873ac5ce4d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a93c259c769b809b43ff89a11b053b8be0128b8248a0a45c2d5e9516eb35378c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef15f4f47d021f2443de965f56fda3dac8914fc9576f97ffc0f5c9519fe93bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "261461e64177fd675f27b8797273a7070034baea64cfe145b0484254ad981349"
    sha256 cellar: :any_skip_relocation, ventura:        "6c04e5394aa194caf8fc62ac9e41b678583209f8d50411d9ed9abd88b34dd00d"
    sha256 cellar: :any_skip_relocation, monterey:       "57f45a957f74ea8dbffc83e65b1a1a3f30382cd83b71378fd87b1e8cd3fd3014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c38455219e8b612ff2aabce41486a43335e597e7c4eb4b52faf421b6d22a3b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
