class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.28.tar.gz"
  sha256 "563da2d26cfae074dc210697630578cda7610bf4c4f827aadd3fb0af238a0820"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d114f64eaf1c8f4fb17c5ddce91ba3c16863f62e9f5daf26785a98de2c3deeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "498605f6513c503ccc52f70455a9641fbf862f01918e8767c43bc6b5baa69132"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "373ff8c97b039256d2edd633674f2be993d007d3a21fe153431a3ddd33ec74b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "27893865ce7f9d27a13be0fe7e21494d57b898993dc31b831653feafeb992f6d"
    sha256 cellar: :any_skip_relocation, ventura:       "e18825de4322778691f685d274a78058ef4dc2ebdff550c580f1b5c2436a8939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ddbf708281555a409d4c3eb3b6fdd93236b204ce08ec28b2c5da8305b7fb64"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", "completion")
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
