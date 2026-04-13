class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.74.1/snapd_2.74.1.vendor.tar.xz"
  version "2.74.1"
  sha256 "126f41aba651ec36c1d946b389687d937d3e96489b683cffdc4f37bd9deb1d46"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4fdde9c0dd434c50ec1f145aa608224e071a9d19feb63f9b73eb3db997cf77b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fdde9c0dd434c50ec1f145aa608224e071a9d19feb63f9b73eb3db997cf77b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4fdde9c0dd434c50ec1f145aa608224e071a9d19feb63f9b73eb3db997cf77b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8426769329f282d1fe9e3967ea8a18c499baa5e53c72fe4dbcb5bf73696d1b77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2aa78782d3dfebeb3a5544f2e9199e411f906bb573f6c5cca24d563110cb50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ce7582b477a6b33f53dd1734a4182456ddcfe9469cf555dd647331c80106e4"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? "nosecboot" : ""
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cmd/snap"

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
