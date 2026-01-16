class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.73/snapd_2.73.vendor.tar.xz"
  version "2.73"
  sha256 "c47fe0c00df5e153b312b5f6dabec49158c8c872ed1eae5e342229bb229a5d85"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8706a57b65a6403d4c0cb1e080a113b466fa51c223fb39b6c34cd0a6fe37a80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8706a57b65a6403d4c0cb1e080a113b466fa51c223fb39b6c34cd0a6fe37a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8706a57b65a6403d4c0cb1e080a113b466fa51c223fb39b6c34cd0a6fe37a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "542f877dd4c60f00c51e3d1487b60c60de89894584bacbf59ff9c5542276a20f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42bd7a19d6bbb44eabc056aaaf4954e65c29dd3b7c54058781646b58aebde98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfcf7d50e5348a8737bdfaf4a7189e2a3bef3926b7c0e6396b9abdc0c7971d4d"
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
