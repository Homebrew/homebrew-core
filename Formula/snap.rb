class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.57.3/snapd_2.57.3.vendor.tar.xz"
  version "2.57.3"
  sha256 "17187b5846db3b71649792784c4d5d68226ae67585dac253c147c1b244861103"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6d4e2addefd503d9be7c5758c126f923099b8bb5d566a9cd9ace5599ee589a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9188fb9c88b66e2c74258488e9ee5039b0eaa0d47e4f29303985f9a97d79a3da"
    sha256 cellar: :any_skip_relocation, monterey:       "76857f0952172192547771e3d41418912f671753c5dfcc6617b4884abf87aaa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6df7766950cc3974aaa30f0fd272681f6d23cf3ad17f651090df939dece66b89"
    sha256 cellar: :any_skip_relocation, catalina:       "6bc1ac71759d1911239ba09db22bd30f23a26737404bd73351902cb94d7577d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91fe2ccbc740b52683863c98d2a6b0798ac4566ccc9bdf9d7aa756576e372f75"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version
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
