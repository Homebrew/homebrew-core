class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.5.6.tar.gz"
  sha256 "539ed33f0f5094444314b66e459ee192fcea5fadb7c2ff802d8dbca0c6f42266"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f08907add19fe55203fe8473f39bdcb6aa11f30500541f05ab985955f66b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c04cd54aabfda1d455b2eba85d45cd01ac1bbae5591453d9bbf8abfe0297c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43d04b00df1ba84311abfea5f976963bce5373ca2e2e6b26f77d8902bd776671"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e8a10c87020c01f202ea942b50988715764b7c3e1d88643dfde613bcd72bb1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efa30128b6b8f4491e9c2e8d5236003b61772e96e92bc77e495446e4199fd4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d447df42c54b626ccdaded3083391925ba3d83c5295053cd060cbf656851a2d6"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
