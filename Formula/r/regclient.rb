class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "400838ea5b5d7f2e1b8b5c5d7a63dcf0cc1da1dba8b1c49fd7eda9955be468e3"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dd48729731c46b9eb9ff7dba78a9d99f1a4c4fc1cef0c6e0458913bf11baa2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da07056628b6bd72ac7b290efcdaacce52c58baaebe243203187b7c34797c1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13f46452f8f86a90f81dce5576a76885a1c029f7afe554984ce5c17e900c2407"
    sha256 cellar: :any_skip_relocation, sonoma:         "7396358dc08db38cd373a28e741d4e09b9854c86c5f4e62e7837f210b426b41f"
    sha256 cellar: :any_skip_relocation, ventura:        "3f3dab4663a8ad108b47309ec7b538829883357f91be1d910cbecc60415f303d"
    sha256 cellar: :any_skip_relocation, monterey:       "bec6bda6baf296992d21eff1baed95a5190697ea5a4197bc1d4aae809bdad8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b2db24809a4f153e2791a3c33d6740f8e72f43c2ff228d1924eb1535a0ffde5"
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
