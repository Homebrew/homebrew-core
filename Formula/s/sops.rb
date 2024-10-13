class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/getsops/sops"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "d79e8caaef3134d00f759231e8ef587b791996e2e45319ffe83dee1ab01aebda"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e22f5ce17fed2e4704f79bdffc815f283426fb623b9420e0be89658a26040e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e22f5ce17fed2e4704f79bdffc815f283426fb623b9420e0be89658a26040e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e22f5ce17fed2e4704f79bdffc815f283426fb623b9420e0be89658a26040e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f16877a71f0526a575d3777303bc4ad3d2e911a0c5b57e7cbcfd879e0f46b30"
    sha256 cellar: :any_skip_relocation, ventura:       "1f16877a71f0526a575d3777303bc4ad3d2e911a0c5b57e7cbcfd879e0f46b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a964b4b1c32e6343dedfb934d0bd29b42591a9c6408123a7f4ced3b094059be5"
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
