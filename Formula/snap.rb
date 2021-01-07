class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.46/snapd_2.46.vendor.tar.xz"
  version "2.46"
  sha256 "c4f532018ca9d2a5f87a95909b3674f8e299e97ba5cb5575895bcdd29be23db3"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5eab0fff68577152411e85ce6b93598ef3619d886edf68dbc6a658d2f4112f85" => :big_sur
    sha256 "0879922d7e220a6af8e6e14056e3785f105d79a1e5b7c8ed6152fedf891f32bf" => :catalina
    sha256 "548d0fa5791b84ae340c33ce7ee4c00ae34afeac08c40c2dd7865e39e6aa39b0" => :mojave
    sha256 "b79ccf4586bcdd234c108527fcc25e8cba2068f11a22e588095a3cdbbd1f4043" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/snapcore/snapd").install buildpath.children

    cd "src/github.com/snapcore/snapd" do
      system "./mkversion.sh", version
      system "go", "build", *std_go_args, "./cmd/snap"

      bash_completion.install "data/completion/bash/snap"
      zsh_completion.install "data/completion/zsh/_snap"

      (man8/"snap.8").write Utils.safe_popen_read("#{bin}/snap", "help", "--man")
    end
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system "#{bin}/snap", "pack", "pkg"
    system "#{bin}/snap", "version"
  end
end
