class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.71/snapd_2.71.vendor.tar.xz"
  version "2.71"
  sha256 "426fced4b4e06fd36a10f18e6fe1efd21281c4fc73f4ada8bba9db2e80c7ea34"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4787305696d642c90acd82c9c32383ee865b1364e79c7811fdeaa77adfe01b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a275e2d881cded82ba1a445988ce907f6c8df916ff73c755a87b65cc34c7e17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a275e2d881cded82ba1a445988ce907f6c8df916ff73c755a87b65cc34c7e17a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a275e2d881cded82ba1a445988ce907f6c8df916ff73c755a87b65cc34c7e17a"
    sha256 cellar: :any_skip_relocation, sonoma:        "92ac0fb5e80873742f102000a327565fd68ed97012ddffe2795811a978dd61bc"
    sha256 cellar: :any_skip_relocation, ventura:       "92ac0fb5e80873742f102000a327565fd68ed97012ddffe2795811a978dd61bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d584559aca30ee56bbd2fc8912e0c6e546ea72672355c9324e0798d260b2448"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
