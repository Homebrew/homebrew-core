class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "793716e4d5fc00041c8c8c7467b522a4ad79516ea05e3a4259c465a744d4fb89"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84b47b4262af934ddd4487cda314bd5d2afa483af3b28d0d3827240223dc98c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae4bc5e426fe12c769abaeefac31b63d3a9c49111f64d4da4ab68b5b270f2041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aab2bb2d60fa73c274edd3c9e7b2edb9b6cebcd632ab1964e8be6cb16b651e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "222c69df9aa93fc94389953b467292599d03db3fbe9ba3e173a1f4e0a9888437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4eeea2a2679ad8159410ccb219ecf5649800dd0d8fb19fd7a75f37d04c5fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a36ac77acb2181d1295aaaca6c478675640cc734cf6fdd29f6cfaab4f73df4"
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
