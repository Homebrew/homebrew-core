class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "f2a87fb940f212d94547f4241d11f3392a0b3c13d5b7bc4584780d8aa80716ae"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca31595b7044786a80e300c3345be15d056f51affbef5fd8605bfb55205bcbb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "094f3bb0f9ff19f4bd3d43bc18b0c445fe5ace6b74018b251ec6dee85e8d7bca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209c1be8ae41804ea290b31f1e8e99fcaa6fe020b597fd848a844cfc4dfe4572"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e89d7d3a91078e6d45055301fea720867b3059dfe2f4ef2ca49cbb4feebfa01"
    sha256 cellar: :any_skip_relocation, ventura:        "53e579e38295361e42be266bb6a32f001848822169c27c2a289450be9ff9be99"
    sha256 cellar: :any_skip_relocation, monterey:       "609e8fe23a90dbd434cbfe5fa8261ac8987cdd6d475827feb1dde4fe779963aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aa9c57ccfaaeada1b3eba910f710274feb36c138cc4a97ea84602ee53861c7d"
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
