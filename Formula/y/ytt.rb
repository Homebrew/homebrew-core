class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "a7266830e05a5119056e7f36c2363e130ca1da1ea6250b62c83bfd377f603c23"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb382b72203c78f0a03cce6f50a48c7766e078d467b5cf1d45bfc3490e31f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb382b72203c78f0a03cce6f50a48c7766e078d467b5cf1d45bfc3490e31f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb382b72203c78f0a03cce6f50a48c7766e078d467b5cf1d45bfc3490e31f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab166b26c6d57ad93d593b2f5b9d41f0c9e60d31bab122e3213c53e04181468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a114d21346914a9cfbd4bf7d026803af1199e586ee68b5cf650bc8023cae3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4507f2c7745c2f1a61a259b22754416f63513e0fa4b097d1ec0dd729855b71a8"
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
