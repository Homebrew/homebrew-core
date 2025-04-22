class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "65fec6001e8be460576c92274524cb7da27932bd466720de95352b66ecc56cfe"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa9dfd49b5c3fff91aef6d7b696a03d88f3a92302578286b3295a03964cb957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa9dfd49b5c3fff91aef6d7b696a03d88f3a92302578286b3295a03964cb957"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aa9dfd49b5c3fff91aef6d7b696a03d88f3a92302578286b3295a03964cb957"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ea5dc090f5917e5714eb95b6d6352468d2665498d8815da7e75c2ced4347dd"
    sha256 cellar: :any_skip_relocation, ventura:       "21ea5dc090f5917e5714eb95b6d6352468d2665498d8815da7e75c2ced4347dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "505c359af9a56a9fda17957d9f6dab4c8d4ea830b2a85523be736da4a324fc05"
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
