class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "5d1bbcf5b2bfb5967af17dac385f0a442fd4657fe08b6fc8283d83bfcfc09ab7"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18896cf5f0f1009cca51180275d8c5c6743dddc711ce8fb9e4b82c8ad2126788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18896cf5f0f1009cca51180275d8c5c6743dddc711ce8fb9e4b82c8ad2126788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18896cf5f0f1009cca51180275d8c5c6743dddc711ce8fb9e4b82c8ad2126788"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6da903f74d49b85f7273a666ac2a7b6834b0c57367a7d47c4d49c328f27480d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87459883940a05a4d222b35acaa717533b325563e5c61359d155cc31e7c84fb6"
    sha256 cellar: :any,                 x86_64_linux:  "09dda86ab7bf335777e9ebaf574e09cc35de5a162c85726b7af8e9d5fb3d7763"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
