class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "4591a3b659dba43a6e8b3d5dd2ef9cb03011868bacab66684c0cfb6b7a698eb1"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49c2512a79b4efe7bc1dd3a124361e6efc6fc3086174682b4566b4845c473cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49c2512a79b4efe7bc1dd3a124361e6efc6fc3086174682b4566b4845c473cb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c2512a79b4efe7bc1dd3a124361e6efc6fc3086174682b4566b4845c473cb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc030271391010313aec7599176946381bf241fd2f59fd7fa0e6a97410550de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96a0cdf8f82d9f8b88026554ccbc3facf11ce35307b5293e20a6b80535c75609"
    sha256 cellar: :any,                 x86_64_linux:  "2218d229cb67ca11821e44411734247eb1504d53feb7fd19cdca4fc1990bf3f5"
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
