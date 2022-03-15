class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.1.tar.gz"
  sha256 "b9004ebdd7a66eff15d160fe795b7f3c5577af7c316f896e7e05418e89c3792c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849c7ae448e6af49f1ed6a6b64a559c9a07b840a19013fa7adaec738bc945f6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a643b77c571d9d26a9227f59b55b884725abe0d86edc39639d64acc56866c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "98cbab6fbd04041bebe75f8bc1cae81b48dd0738b2c2492baaf4486cc908e525"
    sha256 cellar: :any_skip_relocation, big_sur:        "a30d6323556789e412c02168fa352eb8a520c1faf66c94633b856f1368318059"
    sha256 cellar: :any_skip_relocation, catalina:       "e023fd3db914eb5703ba2c35f47f15a6ec86d7021414cb7737a2958adee35800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96a4678e2800c65c145120c218066128fd78fd16c63a4b1ffc5d10854ba96ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-X cmd.Version=#{version}",
            "-o", bin/"vt", "./vt/main.go"

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "bash")
    (bash_completion/"vt").write output

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "zsh")
    (zsh_completion/"_vt").write output
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
