class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "24b1f23a677535d1e06b63f8b4f7793d4f325b86c5454724fac90f5e73903e26"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b09a92006fe701494f378f8a58faf1c3dfae6932b1ab217725a1728542b8bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b09a92006fe701494f378f8a58faf1c3dfae6932b1ab217725a1728542b8bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b09a92006fe701494f378f8a58faf1c3dfae6932b1ab217725a1728542b8bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86665bedc9eb0c2deac9d82c532b0c9155339aef946dbe99b2b210ea227a916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04c65a6452f9fe980b379c9aedb1db807c03050f17f492b52f1b4d28b68880dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d076dd279b45587a24becd3b54a0b9974621ef89e3fa7ee880f253cc0994f0f9"
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
