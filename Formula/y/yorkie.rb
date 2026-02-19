class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.48.tar.gz"
  sha256 "0b060bcfeaace3efbb9c17c78f1d13314948708890c3a5a8d7063e354f619f4a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "169e15fa8a00ca05452386223a76d461b01c73975c6f8723d5399b0fb6fca199"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d7e81e765faf9f0cf6997adfc5f119e3a32c4488151473d113f0e74ca4fed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599034cbe36cfdb2077d52aad8157f0c1ef071fa1fa57654a6bcef9f1686028b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0aec41ee8f2bccf6be87018a5944ba50aaeda8480b9c143cb753b0b39b7f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c9f1c66b1f7ca0424a4857f22da2501d471fd89c1bfe48375e74f918e85a256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975749c5496d22dd4b02e33824732dffb40aba7f4d7a821ece68c71a3f146123"
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
