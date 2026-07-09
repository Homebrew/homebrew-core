class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.13.2.tar.gz"
  sha256 "79560b53814e20031d094a293d6c169314eaaf97efd6e95a6d765e61e881db2c"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ed391090ac94947860c863599f87f766d86164a145bc5fdfa2826f203826480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed391090ac94947860c863599f87f766d86164a145bc5fdfa2826f203826480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed391090ac94947860c863599f87f766d86164a145bc5fdfa2826f203826480"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b7a09752982ec62d55d521d63fa768d034d5ac3b3164220b2d1cfe866bc565c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e51868331295c2ec80357b0a6787c5c10a5ba58f2573ce16e21306ba6021cec4"
    sha256 cellar: :any,                 x86_64_linux:  "370d21683b28858c1be35e58291efcee2c419e09bc3308f6e2460e53b59e0f69"
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
