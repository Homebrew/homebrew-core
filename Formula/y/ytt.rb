class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "1501389183ba44046e55ae76b4d6b4bff9a162f0c74ddbafbfce7723930217af"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed3eac89c8f22af057743593217a71e41048da6aac63b097518d3950f7611f1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed3eac89c8f22af057743593217a71e41048da6aac63b097518d3950f7611f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed3eac89c8f22af057743593217a71e41048da6aac63b097518d3950f7611f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5450b0fe661ec257f8b415e7899a1c3d19b00d480ffb072086ded911f5143116"
    sha256 cellar: :any,                 x86_64_linux:      "c79eb38e462840f93cb882c66199d46a4c53b2a18c07008a29bc0c60b7a20964"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X carvel.dev/ytt/pkg/version.Version=#{version}"
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
