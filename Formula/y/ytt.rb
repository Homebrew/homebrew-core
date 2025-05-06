class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "130758548c465eb2707813890597e59209cb802a9c47b1196969cae0374a07ea"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8abbee75bbe9f764cf8ccc28080d10e22700966bc1533fbe268fcbd5e91eddb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8abbee75bbe9f764cf8ccc28080d10e22700966bc1533fbe268fcbd5e91eddb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8abbee75bbe9f764cf8ccc28080d10e22700966bc1533fbe268fcbd5e91eddb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "162afff45fc8af482a35996c709f197e4c550d6d83fc6f30f834d94c6ad5378b"
    sha256 cellar: :any_skip_relocation, ventura:       "162afff45fc8af482a35996c709f197e4c550d6d83fc6f30f834d94c6ad5378b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810e7536d4c05e5f46519de42b9b5d18a242eed31de410158eda1f4ce8b146f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/ytt/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ytt"

    generate_completions_from_executable(bin/"ytt", "completion")
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
