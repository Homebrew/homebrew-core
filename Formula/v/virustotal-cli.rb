class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.3.0.tar.gz"
  sha256 "10a6edbbb7c81e6978ac55f65544b916906c9400d596beb2fe54f1093a3f7f98"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f956db59fc8a7ec3172cd02ba5de8f5c178971c60c6feb38d3dee3ba1bdc0742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f956db59fc8a7ec3172cd02ba5de8f5c178971c60c6feb38d3dee3ba1bdc0742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f956db59fc8a7ec3172cd02ba5de8f5c178971c60c6feb38d3dee3ba1bdc0742"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb723b9f87be9cd427b2f63f47353da64dea17d8f71c2b75199ad3c215a4de53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6125dfa1c0be784e7505ebc359f6180686b2a1c6e526710af5e6eda1444c70fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0372fc134276136d63cdd731fa3e42467fd3e132834c5e081c30624b13c72851"
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
