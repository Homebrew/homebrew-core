class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.43.tar.gz"
  sha256 "5656a847bcd7be8aeaa394e05f27d6ed73c16d0d5205c5944861d96336ee992a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "775b8701f24b2f6af1feae2ee44bcf53b6a55c96c9cd1d2774bbc8cca3a58d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68167d872828451a864abd59844faaf9fdf4059237ef01dbfee9cefe48c13b11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3086db7523ce2b1449ae5bc301c9b93a8aef4b3ea9fc97947dfc29dbf0ae5adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f96f3872d74c2fe264f6f380511a34c331a22a2c68a51254d1203cd41870a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c29d393a4457acfe76dbc68f9ecb0425a0cd8d1975ebe04bc4b0ce379a454ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f21bd8fe70f690282720c523740fc9b8a6dc20e05dce586e61093ba715fbc8"
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
