class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "400838ea5b5d7f2e1b8b5c5d7a63dcf0cc1da1dba8b1c49fd7eda9955be468e3"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20ab870ceae6867470a3516c20f67e6d6f5d28622e04d4f169c4f7d5063e1a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dde61df5bc145c429a90be9fdcc9b88ff10dd45f6b45e6b6fbd0c87874e93bf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6629c61bd01f6ebb090b84ac9ec7b7067bde3dc7c5dcc354e9c9572cd514d8e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "455bf06adedcbd147efb2d462fba441426b8a653a900758ed6ec7fe1f88c0981"
    sha256 cellar: :any_skip_relocation, ventura:        "a71391a7306a2395592a50676763b96803d56bc9194191dc925cb4b5a2aba656"
    sha256 cellar: :any_skip_relocation, monterey:       "28050f61b77ad1b3c7148350c3a43a0deea6b4bdfe89b505e9ed172427fe0a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e42858d0038f19e35dd2a3879cdbcbdd99555520ece15b19f70351e2e63a343"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, "completion", base_name: f)
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "application/vnd.docker.distribution.manifest.list.v2+json", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end
