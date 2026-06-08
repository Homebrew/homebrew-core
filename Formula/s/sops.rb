class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "60408fa04a024328e6142c7dc67d08810a470aaa440b9f6cb7b3a358359636e9"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01e0765d3db7c73c3595c979cd6e4633249ea52f5afe5fc00d731c9ccac0ed9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01e0765d3db7c73c3595c979cd6e4633249ea52f5afe5fc00d731c9ccac0ed9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01e0765d3db7c73c3595c979cd6e4633249ea52f5afe5fc00d731c9ccac0ed9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c77e5ae27b25d89ce1110ce377e450e933e12770bf461d5f8e60e37d41e1c4c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c6b9fffcf763da6b0e93215c3d006c98b8512f45e65adae805bbbdca58a2f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44414b8e47da7cd4eba3b904151f281cd23014d6d80558b3667a55cd0300e139"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"
    pkgshare.install "example.yaml"

    generate_completions_from_executable(bin/"sops", shell_parameter_format: :cobra, shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
