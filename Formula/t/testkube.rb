class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.34.tar.gz"
  sha256 "a06aa9985daa86c05c74fec7328dad9b3922411a31ac6720e8f8df10239d09bb"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5486309ffbaace76f14048ec06aa2f3eb96df581ff0a3484bd356412a518d229"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cb38f8abf0b4680ef4ec8380f9754f169cf109570ce677aa4ca5ea10262f47c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "866adc7b150e97ee1ffad60e3549a2b492059a5193b25c8379b305e8af1fd9f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7440c98047b15404e7857e106bee34495d20a2bb69b077e0b8d887a33561476f"
    sha256 cellar: :any_skip_relocation, ventura:        "a479c96d0611b27161fe982ab919ffb803a1fa9d0c452ab55728b3e37de2eb09"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9c22069826915ee773b32e1ab780d58652651bee2f8cd85af02b0b7e881334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a6f813f05f998cb8b894c77c6d6f7deca1da2aa2e11c6d0b6268c55d555b052"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
