class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://virustotal.github.io/vt-cli/"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.3.1.tar.gz"
  sha256 "3d95ddab1da71ee769ec65e3ed087994fc837d2d234f9c2640c669c8ce8c7d7a"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ef27865e7e8562a51b369f9a7c7bfa1dde9378572212fade7521e8c55f1228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10ef27865e7e8562a51b369f9a7c7bfa1dde9378572212fade7521e8c55f1228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ef27865e7e8562a51b369f9a7c7bfa1dde9378572212fade7521e8c55f1228"
    sha256 cellar: :any_skip_relocation, sonoma:        "59630cb95ca9ecba9b80553e8ce864c0c45fb2d61536539a904c7795b9030be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bae4d7cac0aabba3f96ae4b89ea0d1f07ddd8c3a0ba6af6d0789042262cf1bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5f8e1d61eae35ef4ccb11098c5cba6c4f93a35a7900af8d66bb7feef00cbb52"
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
