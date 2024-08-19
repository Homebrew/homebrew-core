class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/getsops/sops"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "eda01428a4178903b2d9552940fe441d93fab7b4582cd3f5fee7b6b73404d8cb"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dab5974dd8ac923b4accda24ed7870e276be4c57c9ceea93ccbc8b9a4e17f16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7324ab153b35c9a3a91dffa71f7439bdb2d55517a3cdbfba8c51e83563550a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5673e97c614897b740bfd2e73ccea03575604d32dc460896a3fd63673025b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "afc184e9aa7e08e5a3e1dafe30a84318e6620bd3a256a3ecacf4cc8959176080"
    sha256 cellar: :any_skip_relocation, ventura:        "2efcf25ad7fcbaf94fcd05c4955712624695c9d1243ccce61ba91fd04a55af69"
    sha256 cellar: :any_skip_relocation, monterey:       "aada106c2788e94fcf92d111e583f32311048f2b6ca75a8e0add655f0ed6cea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "817550a1b32ce9ba87701d51a50d9eedcfba936fd7bd8dd41484c9f590e14056"
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
