class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "372bbe5fa01c5f1a68043d27def549c231c78d73c0d8a0d436a83247ad608907"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "506ada645f546c316fd828588dc0968955aa9d23cf9168bdea965224f8ef930d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1e24421e9aa467bde8ff5017cccbd43a2b1eb7a20b5e3da1b1007cebdd9f90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b68d6dcf9e4f916ed4fa66b65fbd231d24f9895ca7c0e7c61f58cfa8f1f6f65"
    sha256 cellar: :any_skip_relocation, sonoma:        "8009d262f49c5ee01bcf8ddea3c4ec91958c64d088e8868752260996703623df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "900df94f459d9e41bced2865ed9964f042ffb39fb97abcaf3d17cb3b028264aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fee65e3d4fefafea91eacaab293fe85c0f30aef5c431caf4d56e2adcaf935c1"
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
