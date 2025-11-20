class Videoalchemy < Formula
  desc "Toolkit expanding video processing capabilities"
  homepage "https://viddotech.github.io/videoalchemy/"
  url "https://github.com/viddotech/videoalchemy/archive/refs/tags/1.0.0.tar.gz"
  sha256 "1ad4ab7e1037a84a7a894ff7dd5e0e3b1b33ded684eace4cadc606632bbc5e3d"
  license "MIT"
  head "https://github.com/viddotech/videoalchemy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1670c950b06ac91c73f850beb664762fcc4a9dc60a8191b95e1f71ab199935a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90306872d961d0f3b3faa8591c95d22f55f989d5176e3365b7e03a1f158ed24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f90306872d961d0f3b3faa8591c95d22f55f989d5176e3365b7e03a1f158ed24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f90306872d961d0f3b3faa8591c95d22f55f989d5176e3365b7e03a1f158ed24"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e949c0b167c2278117aa0e3340c623b67419920e1de8c933f016581fd183579"
    sha256 cellar: :any_skip_relocation, ventura:       "2e949c0b167c2278117aa0e3340c623b67419920e1de8c933f016581fd183579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02e3e7dc86988f811270fb9459edd3332229f25d259b20857db90c1946144578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f53966609f56765856602f4a631171eaafeefb0fb2bb6bc9bf26fc25650ddc92"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/compose"

    generate_completions_from_executable(bin/"videoalchemy", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
