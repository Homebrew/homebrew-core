class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "cbe8cf25d65d03eaa994b3b39d8b1efdbc27db75e0482839109ebb43dbdc420f"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fb54246d51145191c82418d5bf51063442508e757eff3fbfa60f2abef4d62c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564d5bb9b098be4ffa6f24692a038971c04f81c45c71d072320eded2240d58e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1b315f8cb490b457780efe177b5c839fbd3645c33ad705dc20eb221695cd94"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f4e4e4f11c5b7d0437c01ab3c97c324dedf7c9a79fe2dc3d40a21e9de4f0c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae835a72887d4b2b876472e696eef4b866991a9733dff730d7e99d7a81bcaf7"
    sha256 cellar: :any,                 x86_64_linux:  "2feafadbe329ee6f725a8ba1e1a5fb8d13bee00dca321f633dd105de51b3adc1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end
