class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.76.2/snapd_2.76.2.vendor.tar.xz"
  sha256 "873fedb8525057c2b276003c2f90c2e5f7b541ec1bb409a6f489c51b5c72af2b"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34dfd148c71d8ebcca985776c4abc455d27ea83ed6fb3765c153df7153d75cf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34dfd148c71d8ebcca985776c4abc455d27ea83ed6fb3765c153df7153d75cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34dfd148c71d8ebcca985776c4abc455d27ea83ed6fb3765c153df7153d75cf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2cc22b3efa302c8f10ef0657927c5dfbc73bb59067ea4436f6da6b057105e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b72a7f8443b7c9e745ada55cf8eefd2ee7b706489cf6e8d7f4995411ee64f9d"
    sha256 cellar: :any,                 x86_64_linux:  "58dafa572fcb81783e41b08472e452704fc9434110ffdb8ca11b840477c712ac"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? "nosecboot" : ""
    system "go", "build", *std_go_args(tags:), "./cmd/snap"

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
