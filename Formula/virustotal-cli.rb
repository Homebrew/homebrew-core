class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.13.0.tar.gz"
  sha256 "0908250bf659cb73be748da7a1c5d2d402aba0c9da0fc21a1ad629deb4f24a73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60e69ef5580692fc032b137662d1d12efce9cce6c72232d0f14595508b5aef1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60e69ef5580692fc032b137662d1d12efce9cce6c72232d0f14595508b5aef1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60e69ef5580692fc032b137662d1d12efce9cce6c72232d0f14595508b5aef1c"
    sha256 cellar: :any_skip_relocation, ventura:        "8aabe8fb702a176f2ac5f455659433f797cd2d4f37e028d9af1e2c4a668f1162"
    sha256 cellar: :any_skip_relocation, monterey:       "8aabe8fb702a176f2ac5f455659433f797cd2d4f37e028d9af1e2c4a668f1162"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aabe8fb702a176f2ac5f455659433f797cd2d4f37e028d9af1e2c4a668f1162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9d351ff0ee7f1e6b422911a3f98be5899b2e96121bfef4f9d07c136159f889"
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
