class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.55.4.tar.gz"
  sha256 "4a970198c479330c49019be4ccb56513a58623e1e10300d1d188f30e14935a61"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26c958b6072705f2b5f99736988c66512ad1d683816103803654b69ffc413647"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26c958b6072705f2b5f99736988c66512ad1d683816103803654b69ffc413647"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26c958b6072705f2b5f99736988c66512ad1d683816103803654b69ffc413647"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "974da88c012968da79751db594567434b1b8c7e1f4ed00b1f297b86de1971525"
    sha256 cellar: :any,                 x86_64_linux:      "3e5bc79a3b442accacc7f026b0978d45862c2031009b8258cb4c408208ae37a8"
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
