class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "60fe4573a91912568120a493d8aa833ca1e579df3c8d45f85772a4b52330b4c3"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ffcddd5571f969d867488af1734a84a2cee6b4cf306f5741ad426251d3b568c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ffcddd5571f969d867488af1734a84a2cee6b4cf306f5741ad426251d3b568c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ffcddd5571f969d867488af1734a84a2cee6b4cf306f5741ad426251d3b568c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b0f8f605cbe7cdebb1905b13c6dec67a0a2dd12ee854abf28d703c7329168a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca28ea91505c41bac040a42ad22b5d1b36d483e57fb97cd17cc5bfe5b71137b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e8252379d4fc41acea18903d508d165cd87b86e75fa6fbc7718621bcc8fd75"
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
