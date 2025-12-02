class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "c02a8dbcff7f7cf3a92ac6a210d299dd5df13946625e092fa2da48622a8e2fec"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df0049384c4b323958071878cb575eb05b8f4ed31d318bc3e2d721752bd3b2e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df0049384c4b323958071878cb575eb05b8f4ed31d318bc3e2d721752bd3b2e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df0049384c4b323958071878cb575eb05b8f4ed31d318bc3e2d721752bd3b2e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df0049384c4b323958071878cb575eb05b8f4ed31d318bc3e2d721752bd3b2e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "551e538f70010d174fe740c7fb952a2a4c5e65c842b7cbb8ff35bfa05124de43"
    sha256 cellar: :any_skip_relocation, ventura:       "551e538f70010d174fe740c7fb952a2a4c5e65c842b7cbb8ff35bfa05124de43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ef1bf1260bd779d5f9bf9583cccdcaa354fd0f38e87f2442e93cfdd72579a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5387c59c39c72bdd4425f8d0d54b338b5c0b4f4f5fa642f618a824285a490faa"
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
