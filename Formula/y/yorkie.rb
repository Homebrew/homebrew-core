class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.14.tar.gz"
  sha256 "c468caf7f18b56531d6290318db1d45536cdd600fe917be4ba7aeb8f26c8b663"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55ad871646ef3656d3263147ee6f64a6344207404109df4dc5f32a31e30c0226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ad871646ef3656d3263147ee6f64a6344207404109df4dc5f32a31e30c0226"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55ad871646ef3656d3263147ee6f64a6344207404109df4dc5f32a31e30c0226"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f844f4aede5724124f11820bc091b44c147ea9bd663fe0497e84c895f9299d9"
    sha256 cellar: :any_skip_relocation, ventura:       "5f844f4aede5724124f11820bc091b44c147ea9bd663fe0497e84c895f9299d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c004a468c1d1db4e4b9e1c86c396f90849030141d2fa70dfd9f8e7ad51e7f8a"
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
