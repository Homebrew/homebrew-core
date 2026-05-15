class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "0d67133278ec9e104d4082a9dd7cc312f32be7a1be86881b2ccc4bc55510585d"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ecac531c20fb80bb0aa450813d1a5fbfcda3ecc5cfbe8169d1a4eba249a6142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36387a7a6088649f9c02e64c0d40d957da9e39c1da5d5bedf556e75768a2dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4b8d7d0d53386f72a0a7d0c3052a829901aef93206441804564b3a85302b53d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f5fdbde7d18d9545834469210fd0d4e721a05ac7e77cf687f36485ab00801f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5698e5a1d5a8bbe1355d13d013799eb70b089ba9ad3707aaa83f8daa1c89b410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47470b3869487ee4fe37c5c9ca3b9abaea4e7b76c23e4675d45ef3fc28db4e5b"
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
