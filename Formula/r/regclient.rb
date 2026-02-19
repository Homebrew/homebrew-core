class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "e4e5a420d41feeb6e9cd1d2bd41d6d1935e37c17c880737aefe3f67ac48f3583"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b0e28ade4c13dc0bebc51e032e6bd72525bd35f546e169187396893b04bc48e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b0e28ade4c13dc0bebc51e032e6bd72525bd35f546e169187396893b04bc48e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b0e28ade4c13dc0bebc51e032e6bd72525bd35f546e169187396893b04bc48e"
    sha256 cellar: :any_skip_relocation, sonoma:        "803554b5897f50285af54d56768debc97acf497562eb79fbe7e492d2dfd39b15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07fadb96eb705a04d080dac7ca164d05d5b1e3f11584fa6b9c67d37a9c4e9938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f22dcc005d4cdebbc8acc4047a8bcb1f1aeda086c58c27f3b7fd3d038b14a3"
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
