class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/getsops/sops"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.9.3.tar.gz"
  sha256 "07f21ad574df8153d28f9bcd0a6e5d03c436cb9a45664a9af767a70a7d7662b9"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1aa5657001bfb39de354d1b42fb91f94bbdb0c62544d4c7c80fec95a7b735d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1aa5657001bfb39de354d1b42fb91f94bbdb0c62544d4c7c80fec95a7b735d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1aa5657001bfb39de354d1b42fb91f94bbdb0c62544d4c7c80fec95a7b735d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb824d40c379d40802ead1a4c869ecdf51188acf2e60dd9a7731788f403a4d6"
    sha256 cellar: :any_skip_relocation, ventura:       "4cb824d40c379d40802ead1a4c869ecdf51188acf2e60dd9a7731788f403a4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9587e34c689d4993d2881b0e687b01cf7bca38c74e6b2f91ce30fc4b304c207"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "tidy"

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
