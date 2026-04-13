class Ytt < Formula
  desc "YAML templating tool that works on YAML structure instead of text"
  homepage "https://carvel.dev/ytt/"
  url "https://github.com/carvel-dev/ytt/archive/refs/tags/v0.53.2.tar.gz"
  sha256 "cae3f16c1b2c97e795a1aa3eee6362a2887eb78f71e4458be8fc8fceb0f68451"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/ytt.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef872144e12219300dc589c55b5e44aa4cdee98b326a1a708ebe0583ee41a2e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef872144e12219300dc589c55b5e44aa4cdee98b326a1a708ebe0583ee41a2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef872144e12219300dc589c55b5e44aa4cdee98b326a1a708ebe0583ee41a2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "29baa78a57d792cd83c12269d34c9724952053061d1bb3018f18068eb4ba2890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a26d4ccdf5f4f775299fc70636823a146ead51d08a3766d0defac51b54d59d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a1b1410565b65c5b191e977b0d2da862824063aa2ece7a08449be515b0125a"
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
