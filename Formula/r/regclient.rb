class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://github.com/regclient/regclient/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "64ffd66661a88cf8357ad9e961901cc64f926a5d1e0c6cfafeb12ed2023c18b3"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef4cda4c96eaf436865d9a12cd987676cd72df019c6fabf310965561566db47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef4cda4c96eaf436865d9a12cd987676cd72df019c6fabf310965561566db47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ef4cda4c96eaf436865d9a12cd987676cd72df019c6fabf310965561566db47"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d779eb3761573d30491d5635614b5eb669bd1852f9ee1415ae52781d95b450"
    sha256 cellar: :any_skip_relocation, ventura:       "c5d779eb3761573d30491d5635614b5eb669bd1852f9ee1415ae52781d95b450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27d90736256354cdebaaab6050078ad7056c074b736f82db62fe0ec290db0d8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, "completion")
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
