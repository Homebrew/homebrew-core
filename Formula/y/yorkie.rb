class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "c2619fd7a6df84bc776dd589d5c0ce389d693ac41d8b3d08a37e759a7bbbe219"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239f83d75eec73f992759c5c003bfc09644962c9f40e02c309d96a333c913a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239f83d75eec73f992759c5c003bfc09644962c9f40e02c309d96a333c913a9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "239f83d75eec73f992759c5c003bfc09644962c9f40e02c309d96a333c913a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "66ad306b5cfe9705a0b1f5758c6ecd74d2bdd08fdede68cf73fe83de960b9e93"
    sha256 cellar: :any_skip_relocation, ventura:       "66ad306b5cfe9705a0b1f5758c6ecd74d2bdd08fdede68cf73fe83de960b9e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "851c6dfbe23aaf8b52458bd540a19596e66af8e37d5e7b6a6e4a42c1fd1f3cec"
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
