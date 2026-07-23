class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.13.3.tar.gz"
  sha256 "49811c5ed80f6b4d4e98cef98e3f7378406aa692fd773dfb72ad1b4dfb940448"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baeff34ec84e339c8b1e3d930e53243a417c897b73773c47f73d68db43c5448a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baeff34ec84e339c8b1e3d930e53243a417c897b73773c47f73d68db43c5448a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baeff34ec84e339c8b1e3d930e53243a417c897b73773c47f73d68db43c5448a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b6a117d057d0a8c69e126da14594df56dc8539c8a4ff1e45c306dca0483e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bba36aab53ddd2c9e404422eb921a018eb6945db8511ccd791208cb276f8ce0"
    sha256 cellar: :any,                 x86_64_linux:  "f913f6bb7b4a05f36e8b7080c4f8279ae8cbd23a772f1324cf5b93e322449c85"
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

    expected = "Recovery failed because no master key was able to decrypt the file."
    assert_match expected, shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
