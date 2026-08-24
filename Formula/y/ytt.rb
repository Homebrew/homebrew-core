class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.55.2.tar.gz"
  sha256 "e36439c836b24a572f465c8404c53d65eecdca737a6d98e0d79d5e82babe1e4e"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abf4b834dd9a9a35e3c081bee48ae17fa06b6aedf82bf96b21ebd192a33da518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf4b834dd9a9a35e3c081bee48ae17fa06b6aedf82bf96b21ebd192a33da518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf4b834dd9a9a35e3c081bee48ae17fa06b6aedf82bf96b21ebd192a33da518"
    sha256 cellar: :any_skip_relocation, sonoma:        "b78c7d96cc24c024a1837434f7e7260141f38fd634f7abb3633ca3b22b3b40ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f527d2b7c87f083d7bd61ca887d5a2fc2cc37c772e5ee48fc9e357a8758f89e"
    sha256 cellar: :any,                 x86_64_linux:  "53fea3af70d08529a2e8b7def3adee4057ad1626a9d28d333d4963410491a0bc"
  end

  depends_on "go" => :build

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
