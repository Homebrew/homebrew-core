class ShuttleCli < Formula
  desc "CLI for handling shared build and deploy tools between many projects"
  homepage "https://github.com/lunarway/shuttle"
  url "https://github.com/lunarway/shuttle/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "dddc84927c985ec29cbbad7952d8c5e3d6c1fe1bcd5732c49269d0f517000f90"
  license "Apache-2.0"
  head "https://github.com/lunarway/shuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e155472f49226c07b7e6aed2b2b171988b7eb72dbf8f6c0c726272907048a6ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e155472f49226c07b7e6aed2b2b171988b7eb72dbf8f6c0c726272907048a6ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e155472f49226c07b7e6aed2b2b171988b7eb72dbf8f6c0c726272907048a6ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4c203c0e820940809b3947ca17c1612ddee2f7e58a301181a414acaf906739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74cde4615cf2909bcfc049ddcceb1b4361c08511f7cfb7ff1f938d6055090428"
    sha256 cellar: :any,                 x86_64_linux:  "1fbd93fcc9cae06d68da50868b6a86ce49c9fd591872d4250f32de76e51f8d46"
  end

  depends_on "go" => :build

  conflicts_with "cargo-shuttle", because: "both install `shuttle` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/lunarway/shuttle/cmd.version=#{version}
      -X github.com/lunarway/shuttle/cmd.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"shuttle", ldflags:)

    generate_completions_from_executable(bin/"shuttle", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle version")

    (testpath/"shuttle.yaml").write <<~YAML
      plan: 'https://github.com/lunarway/shuttle-example-go-plan.git'
      vars:
        docker:
          baseImage: golang
          baseTag: stretch
          destImage: repo-project
          destTag: latest
    YAML

    assert_match "Plan:", shell_output("#{bin}/shuttle config")

    output = shell_output("#{bin}/shuttle telemetry upload 2>&1", 1)
    assert_match "SHUTTLE_REMOTE_TRACING_URL or upload-url is not set", output
  end
end
