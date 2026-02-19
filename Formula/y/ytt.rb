class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.53.1.tar.gz"
  sha256 "e5c34bf6be8bec3191e7b28dae47d91e66417161e20d2a8e4fef073192859b25"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d21b5f01e5ed94717271b0a48dcc9e5807e79016e48abc0d3025feb6c49d07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71d21b5f01e5ed94717271b0a48dcc9e5807e79016e48abc0d3025feb6c49d07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71d21b5f01e5ed94717271b0a48dcc9e5807e79016e48abc0d3025feb6c49d07"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad525139767c1827f532c72ca6d62b33705db765bdd9c80f495a6351fb5e168b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f17b866955954e24116e5673b1a2a57b82a7da6ed168f0bb5e14bd7e61e2e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a85994d696ded0b7943478c26e013e23097c7237f32ba0e3961d3970b8c402b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/ytt/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ytt"

    generate_completions_from_executable(bin/"ytt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytt version")

    (testpath/"values.lib.yml").write <<~YAML
      #@ def func1():
      name: max
      cities:
      - SF
      - LA
      #@ end

      #@ def func2():
      name: joanna
      cities:
      - SF
      #@ end
    YAML

    (testpath/"template.yml").write <<~YAML
      #! YAML library files must be named *.lib.yml
      #@ load("values.lib.yml", "func1", "func2")

      func1_key: #@ func1()
      func2_key: #@ func2()
    YAML

    assert_match <<~YAML, shell_output("#{bin}/ytt -f values.lib.yml -f template.yml")
      func1_key:
        name: max
        cities:
        - SF
        - LA
    YAML
  end
end
