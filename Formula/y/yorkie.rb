class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "a593336b72dc5f4f24c0eea6363318c984381bbc9fdba4e0a22fb7b70221ce7e"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1b35835baf6df8badd354b87590496016ccdfdf51a7eb1c559327838198ffd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "873aa68cc3c69b07ba4e1d6913e6ccf7418a15c86dc4cf132cb98fcc344db16a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f81ac2d5b18cc04278e4ad444b0e262ffeb51247412d789032c20ea5f3acb27"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c940303c71cf75e7ba4ab26af0ba145d458cdf2bce17fbf2ad199cdc7afed8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbcf8b14846409bccf139c4ae47d0cabcdfd4e1857928844237ddb648c929ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "108f6559432f818bc3ba6cca6b124c0d6ecfeaacf9bb6afcf01be1056fe29579"
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
