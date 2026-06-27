class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "893eadb97b8742abbb5126d4d76718dc7da363f33d704ad830423ed66aaf5b84"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "705995f153d4cd96fd5ad9839d8a27ec2921b9a21d98a013ec57bbdd06f9b9bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "747b5caf9013cb2d800d6adc5f27f98edc661a09ddf830f5d85de843ceb61cd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab6480a7e9469a07cb5525a54ce28b2cad2485f1f4368243033a9d57f8dd4af7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfc4df732cd0c795929789a94a77f6a8bba0000aceb29fc26f12e5a317e0468e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d888729f4d73299d0a5976de5b2c92ee846b76e7246a8f5f2dbfe58bb45552"
    sha256 cellar: :any,                 x86_64_linux:  "91ab65637fdc9f7f83d786a564960d22c37360d9864a37a1f5ef6bf31311b013"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = spawn bin/"yorkie", "server"
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
