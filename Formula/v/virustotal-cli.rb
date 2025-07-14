class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.1.1.tar.gz"
  sha256 "c92aaa24254bf0e54d9c413dba4f2889757292387614ba67a968153419012869"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d54b73d1f8550693d2bd2446289f6e65352aeec73781102a83747361a06583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85d54b73d1f8550693d2bd2446289f6e65352aeec73781102a83747361a06583"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85d54b73d1f8550693d2bd2446289f6e65352aeec73781102a83747361a06583"
    sha256 cellar: :any_skip_relocation, sonoma:        "febfc257b383284f956c644a9c8e5792e083bf0beb98c7a7f29f3cd9d118679b"
    sha256 cellar: :any_skip_relocation, ventura:       "febfc257b383284f956c644a9c8e5792e083bf0beb98c7a7f29f3cd9d118679b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c227226649ff08e67a3a66867214dbf914ce7c3c65f0ec61cf8a818ac4883a"
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
