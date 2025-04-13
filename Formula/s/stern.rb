class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "a597449d4a4443a45206eb5054676545f74a5cc279a6c48e298e01429e471017"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65bf6ff2ee1634f392e630a76b6953f4674c750b125a9df9dbe0a06637d6e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a95b680314ece8f2fbf490c0ec5826b792f538e74df05c7edb00527e2de75408"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311436853aa51947a75c24127f2c8d8b9e6847d456f64ef18814036d8d333258"
    sha256 cellar: :any_skip_relocation, sonoma:        "39134cc30a1bdbdc6661c0b5012b43de07f80b04ed6692c4900c9c199fc95268"
    sha256 cellar: :any_skip_relocation, ventura:       "bc54ef4005c453f23962ff4cfe6fe2b6c2d29c025e9b822430a163b06465b80c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf9c76970393d3879ab8327c4ab393da590a132b3d0a85df18235d8e5948d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408cdc2e2ad3c0cf59f6f4c10c49a299e2cf387c15f025817ce615b45172f269"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
