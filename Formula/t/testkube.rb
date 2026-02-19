class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.6.2.tar.gz"
  sha256 "505da43514548f083c72f6f386adb27dd6aeb1266f2cace51a33e354477e2c4c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a884a46c00d61f994915465308589026a6d79aac00302b497c4a9fbef6f7cd02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "082e1cdf285ad1a03134c43ba8482b70652976ab201466827326b78d42825590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed7e154bb8532ab74e29ace6cf9c103cad02aaec44de833e5101e43c4f2cc080"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac684bfaea6585611f752ab602d3da075990519f94bae13711ee0bb31fd9f842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43f88290c6709273116bb4ef24dfc0da15a5df745a8293023999a7fdb4a873b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43b4dc3a6498b9d2801fee5b986a18c0b768e5a44941b2266165d7e65cb2ce5f"
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
