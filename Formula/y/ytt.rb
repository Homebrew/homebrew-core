class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "ce442e6dfd26cc0fe2504b16f7aa93d33bd6f8279a757b86b37cfc37dc228d2d"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db9421a9fc31bfd1c4b5fb421d4e23ddab43085c4425c0ecf3878e3604d2acc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9421a9fc31bfd1c4b5fb421d4e23ddab43085c4425c0ecf3878e3604d2acc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9421a9fc31bfd1c4b5fb421d4e23ddab43085c4425c0ecf3878e3604d2acc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85bccf63e87edfab485c1de109458e6b6c974db07de0ee44def330b94978acb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fa82004ba5fcb0990f3e19b9f24c4b94a954bd5a48c45d406730c4cd728f97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ef2be8ededb78e2e7319470a1b5641e64334c52dea4c7b056d555f9d387ac0"
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
