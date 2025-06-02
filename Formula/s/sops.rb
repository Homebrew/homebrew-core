class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "2f7cfa67f23ccc553538450a1c3e3f7666ec934d94034457b3890dbcd49b0469"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94f96e22f7a5e0aa190cd3ad84bd1c69c8a301c82c40c4aa915a7bfd47d3e59b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f96e22f7a5e0aa190cd3ad84bd1c69c8a301c82c40c4aa915a7bfd47d3e59b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94f96e22f7a5e0aa190cd3ad84bd1c69c8a301c82c40c4aa915a7bfd47d3e59b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5103c9c60d2e5117114d429e3f488560127788b9bda5463fb4dff972417bd220"
    sha256 cellar: :any_skip_relocation, ventura:       "5103c9c60d2e5117114d429e3f488560127788b9bda5463fb4dff972417bd220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86539d39f3aef614e81590fb805a61ffd4112dfd5abca1d35e553da388f3d4dd"
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
