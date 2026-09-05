class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "f961402de37b0765c41c2cc5541d547eece09fbff8662345d7248c6c3de61729"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f184d2c65a08204b45508b1d351741b0f04ef53708c89ae0d93c8a69ba481808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3815313ecb55b39ddb6ec3b10616da187c92954d271df35e5cf5bd3d22590f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62fbe603ba30098e225d1e1613052f339bf0fd4e07951bba4a7d042897d5615"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60a0579306d2cda25b11125b2591f2e42c16736e9af902f3d8afc7f365b8de8a"
    sha256 cellar: :any,                 x86_64_linux:  "d4d936a541d9d9ac7d7e5d29ef72e49eca011203c98a04bb0e33d0c50bfa94e2"
  end

  depends_on "go" => :build

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
