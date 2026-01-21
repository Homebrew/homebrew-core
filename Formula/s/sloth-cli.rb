class SlothCli < Formula
  desc "Prometheus SLO generator"
  homepage "https://sloth.dev/"
  url "https://github.com/slok/sloth/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "85c3369845fb44db90603422dddc2ac4f21f28f1bac4994f6e1e91707cd98cba"
  license "Apache-2.0"
  head "https://github.com/slok/sloth.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d48912e0ff06aaecac777e863ae79a8f5e3a4927cb39f0b68df832645da76abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8a11f2892f80a1c88aed87d98a156db15ac20294dc37a3c1710b5907c2a1bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e8262235ea010b346e539c28815d5652459c040ec3880c8c0cec9c84579b53"
    sha256 cellar: :any_skip_relocation, sonoma:        "8011382bc46786eba1e82918d9bae201f759d64e94ffbacedcc8fd2c635cab03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2a7b92a6d7fce7d77419ea056044ff1faaaa14ca24ce574657fb8df9b30d677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d06d3529fc05ca63b8c4c15fa8d7eeb1c48bb9787df738f0f9251fdc1529b380"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/slok/sloth/internal/info.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"sloth", ldflags:), "./cmd/sloth"

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/getting-started.yml"

    output = shell_output("#{bin}/sloth validate -i #{test_file} 2>&1")
    assert_match "Validation succeeded", output

    output = shell_output("#{bin}/sloth generate -i #{test_file} 2>&1")
    assert_match "Plugins loaded", output

    assert_match version.to_s, shell_output("#{bin}/sloth version")
  end
end
