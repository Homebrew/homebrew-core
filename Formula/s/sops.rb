class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.8.1.tar.gz"
  sha256 "5ca70fb4f96797d09012c705a5bb935835896de7bcd063b98d498912b0e645a0"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aa447922f3c179827253fd8d0fe2e087d24a227834b68da3c6ccacda89741d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8625e5a465ed0f5c086108990af51526a01aee3e91de0b6256719fe7bf33f7f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e057fcdf75857cfff891e09640263813730f80987d6d3c681f0473d328b3265b"
    sha256 cellar: :any_skip_relocation, sonoma:         "96e2377dd04ea9e2f6dc0942de2de7ba615846db960954380f34357f2516efc4"
    sha256 cellar: :any_skip_relocation, ventura:        "1aa9ac1ac98054155066da4898ded3e8c0c792714b026c57414368a27d85f06a"
    sha256 cellar: :any_skip_relocation, monterey:       "14178f64db4aa62340dd57d208f02d06336ea8465393171154560d64188ed5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54849414c752566bfde2f0d26cc832c6312831ba7bdb94c35c40eb09e0eaf66"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
