class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.65.3/snapd_2.65.3.vendor.tar.xz"
  version "2.65.3"
  sha256 "67987d2ab9a88a074600f432c07989a87297da78954cfe505d4e0e10a814b7a4"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8be04cf3b5ea4edbfec0180c586527373c2d3bf95ea76a1c6f3916b4e585ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8be04cf3b5ea4edbfec0180c586527373c2d3bf95ea76a1c6f3916b4e585ff9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8be04cf3b5ea4edbfec0180c586527373c2d3bf95ea76a1c6f3916b4e585ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5be2b1aa75f928f02b581139bf763e4e09f81f5ff4c609c79171c0c481ad1dc1"
    sha256 cellar: :any_skip_relocation, ventura:       "5be2b1aa75f928f02b581139bf763e4e09f81f5ff4c609c79171c0c481ad1dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9de9cfdec594dd117edd96d3e0e263187fdc3d750e6c570b9f4996f2d24ed033"
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
    (testpath/"pkg/meta/snap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
