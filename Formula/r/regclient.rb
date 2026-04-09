class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "f09ccd1a9e9872cc3bff957a4a54729643f0869491932d2a074c2974f8e2cb70"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f3f7e04ff5eb537bbacaa2703e1a3cb382a7ed48ea3e1fbd447617a1585d271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f3f7e04ff5eb537bbacaa2703e1a3cb382a7ed48ea3e1fbd447617a1585d271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f3f7e04ff5eb537bbacaa2703e1a3cb382a7ed48ea3e1fbd447617a1585d271"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c276d25723f17b1043a7e269dccbd78dfd47ba8c8672e318e47037054377a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "106b558c014ede4a167f553ab592286cd6e95bae0795d8c9a6c7cebca9130770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f83a6ed6a56a2015323d437a95039d23f1f8c8f6a34f88451c67e8cd5d4cd0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, shell_parameter_format: :cobra)
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "docker.io/library/alpine:latest", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end
