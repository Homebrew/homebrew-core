class Videoalchemy < Formula
  desc "Toolkit expanding video processing capabilities"
  homepage "https://viddotech.github.io/videoalchemy/"
  url "https://github.com/viddotech/videoalchemy/archive/refs/tags/1.0.0.tar.gz"
  sha256 "1ad4ab7e1037a84a7a894ff7dd5e0e3b1b33ded684eace4cadc606632bbc5e3d"
  license "MIT"
  head "https://github.com/viddotech/videoalchemy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d1920eb31c8a15e3e2960eb5d79d232609f85085091dfcde6db588a7e82527c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d1920eb31c8a15e3e2960eb5d79d232609f85085091dfcde6db588a7e82527c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d1920eb31c8a15e3e2960eb5d79d232609f85085091dfcde6db588a7e82527c"
    sha256 cellar: :any_skip_relocation, sonoma:        "163886e323873afd56a3bf782b3e8177733ad4088779760bf710838be2188455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae565a7c2365bbd921dc8a7664ef1eef570865c272d002664bfcbbebfd1b6f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72788fdb6f409d88c925d344d5aac48b217477cb419c3b9ebc249b517bfa412c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/compose"

    generate_completions_from_executable(bin/"videoalchemy", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/videoalchemy --version")

    (testpath/"test.yaml").write <<~YAML
      version: '1.0'
      tasks:
        - name: "Test Task"
          command: "echo Hello, Videoalchemy!"
    YAML

    output = shell_output("#{bin}/videoalchemy compose -f test.yaml")
    assert_match "Validation Error: generate_path => is required", output
  end
end
