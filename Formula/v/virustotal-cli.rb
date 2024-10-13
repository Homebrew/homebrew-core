class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "6cb16e89cd1964c95217c347c1b5a19c930b9125c14976dbd92d46cc324e4aa6"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "25f49bea6abe1687e8f72912e4dde8b370608d4a4aa189fdb11af5e63aab1d7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f309321a7f51f6803a98b9814f59862fc5646c0a4b0e1096b3da002ab8e3eb8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f309321a7f51f6803a98b9814f59862fc5646c0a4b0e1096b3da002ab8e3eb8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f309321a7f51f6803a98b9814f59862fc5646c0a4b0e1096b3da002ab8e3eb8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b5ce2e8074d942a6c7e04863c60b3eebac2bf85616d2b04219adc1424644509"
    sha256 cellar: :any_skip_relocation, ventura:        "5b5ce2e8074d942a6c7e04863c60b3eebac2bf85616d2b04219adc1424644509"
    sha256 cellar: :any_skip_relocation, monterey:       "5b5ce2e8074d942a6c7e04863c60b3eebac2bf85616d2b04219adc1424644509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09709ec89f8c6ee8016c507ac911a7d0d20dd9ea93ca5009538ec6047cd2fb72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
