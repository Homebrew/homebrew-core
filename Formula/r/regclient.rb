class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "0b39f10b7b67d14e355ce6980f69d595dd0572981d5877580eaa9fb39a3ddfb7"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d01e26ad3c73b4633712f58787c4ae7c3d0f1e9c13367d65a38a717c19f24ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cbc8116143d082f423387e28ebe8454b4dffcad3ecf99531f8d93868a23b9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f2251f34df4a20f8cd8067d04030ffcc4390a6d024aeee63851783b44ad25f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5be21f1430404a4ce876b6664aad2265055332b0d4b77e050372dfa52d2bbba4"
    sha256 cellar: :any_skip_relocation, ventura:        "ebe3d45dac76e89c7ed76ac46bf867239f359d048381e44e2020405dbed0c477"
    sha256 cellar: :any_skip_relocation, monterey:       "4665393cda27ea6cf9356fc9c37a3749c993c144616c69b06c7776eaa7886a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f9baf34e3bb77e192f1baef0b01d4b53bdae92beffcb062263206b9e2698a8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/f.to_s), "./cmd/#{f}"

      generate_completions_from_executable(bin/f.to_s, "completion")
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
