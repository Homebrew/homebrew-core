class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "f4060762df17bd3a3a0c09c60301adfe7fed9aae062ff97890905aa696f13732"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10516c7196820c831875a0aea58ec7b12924b4bca23363ee6cf80e658fa82d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67aad1e0872dfe9a0b945c0693e96f1cd45f2e95d9f348ebab16b88216920c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd3a4a4fbc32547d0e56285f9e61174a3906a3c5728723f32acc63ee084b0cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb74dfb370d5945bc6d9e65a73d8df183eb84856bc0ede8a4876a36f415de33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9657ca40f56db76530c9c69dab2a0b9cc4a8bdc17a59c8d2e9c909692bb3c8de"
    sha256 cellar: :any,                 x86_64_linux:  "812420c0deb8f858bb894e42022688f63a1c642702e283f7a2ee4297084c376e"
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
