class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "b010a00f4e08e3a3fe23f70fe3958a8108de8b5d2478388e1fd7e0315e14f2ea"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9d45dd5ff4eabd069310d5b9b3a89aa480f74caf9c4c568a65f32a6e41bbd90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d45dd5ff4eabd069310d5b9b3a89aa480f74caf9c4c568a65f32a6e41bbd90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9d45dd5ff4eabd069310d5b9b3a89aa480f74caf9c4c568a65f32a6e41bbd90"
    sha256 cellar: :any_skip_relocation, sonoma:        "f97c5a55ca21de8c35a24bb0ca50eedaa7832a3cb99145c9c52d660ae6001a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0de3c76239a18b71bf5a3198f65856df9078ab894f83f4639a5bb2196820de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9870849507698703fac19c63b80999761b505974a865d8e015defcb058f055f7"
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
