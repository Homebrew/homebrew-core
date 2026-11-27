class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.16.0.tar.gz"
  sha256 "8aab9f504fc50efca9014f9bede743a4321a7715a271709b1777fa2bf6fe5271"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "021d6159bcb8f32749ecb69d400d5a12839953ae33c300234079f922def497e7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f74f5c17fa9337f356532cd4bec9ed7c391f8a1c8b7bbb8306f957501d6bd17d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2995dc5bafcbf7b0e14d5f8e3181ded9ac561573864efddfd0ddb147dc155ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d78ce4f46a6ba4b56d10538e90fe3e078c34e45f9416188be154416e99c0d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1be759f7affb7df5abbd79cdaa4c19f2ebeba866bf8483be9428d40acd0f862a"
    sha256 cellar: :any,                 x86_64_linux:      "64cfedd132516514917463bb69a90ebfc01551d8f4919008d52788430db592fe"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

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
