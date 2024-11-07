class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "d48e4c3236dad86989ee3c0981bda9a65c2ede700ecd7b7e12364db24c0e73a6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32796298f7583530a1e5c405bcb8cd2c55ed9fdd53bb7a7f4390095fdb05d3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32796298f7583530a1e5c405bcb8cd2c55ed9fdd53bb7a7f4390095fdb05d3a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32796298f7583530a1e5c405bcb8cd2c55ed9fdd53bb7a7f4390095fdb05d3a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5e60f2bc450e585a80c88eedbbd673443515b67d42208fb171c6cf606551891"
    sha256 cellar: :any_skip_relocation, ventura:       "b5e60f2bc450e585a80c88eedbbd673443515b67d42208fb171c6cf606551891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "988ea39bbe1c0939e08b6cb9a114cd58d0d20a8c266bb2bb11745d7f7e2d3017"
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
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
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
