class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.2.0.tar.gz"
  sha256 "4f7cd36b73511709b01448340d904fd4d7e291a50263d0d3f946502a8173fc9c"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6435c7783f637607c200a9610fc0a2eca11237de71245989593fb4a8e82267f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6435c7783f637607c200a9610fc0a2eca11237de71245989593fb4a8e82267f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6435c7783f637607c200a9610fc0a2eca11237de71245989593fb4a8e82267f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d290dab039ad26bd14c6306c662b6fdc04b96831c5925b24677e476da6bfd1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14f862e8f87ce5a7262002c7429afb48765024dfc301372f2b2107e84917a1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e50be69ffd0c5503f14e514af40c632d1d69d7b3c9e959da5e9f6a2c44359b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cmd.Version=#{version}", output: bin/"vt"), "./vt"

    generate_completions_from_executable(bin/"vt", "completion")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
