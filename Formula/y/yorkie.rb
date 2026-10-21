class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.25.tar.gz"
  sha256 "37865315c8a4ae17f79eae1c81ec35ec011405519532526d0fdd48f396d3cd2a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbaa0ce772ca1143ca11febe3cb549ef4b22824a2902dd58a92e696ebccf18ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8802758c51e649d484c6f504dac53ad79ded5ab6229894473bae8afb374562da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "864617f59c6f7823e7f439d97adb1ccda5dd7300e85dc0d68d2167e013b2a5a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15804c96d6e9534a9cca23c55e67bd74f3bcc0977743acf3a188103f57ac0216"
    sha256 cellar: :any,                 x86_64_linux:      "44f2ce0c2c8342f877f5516948fb71adca2ba3f15a98b9858f9984dd17bb0d0a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
