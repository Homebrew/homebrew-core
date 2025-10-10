class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "0182659099cd6a2fbcb41b507f8cd363667a0d6eb442098f6cebdf4ca8ecd2ac"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52994ee8ae4c40be548d83f52e47549788fe07bb4cb04a9700c605d26b773d7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52994ee8ae4c40be548d83f52e47549788fe07bb4cb04a9700c605d26b773d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52994ee8ae4c40be548d83f52e47549788fe07bb4cb04a9700c605d26b773d7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb2334538fae10f195960465f656619f7a123dbe5a7bb21c447715909b14dae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe0236b892c9bb0a7bb74d2d69cfd14303bb46bc992da2577ab380462055303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9557d761c6abc996ce3e66b6411956fcd7c5dd984ee27eb2fe4ad6f0f34f19a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
