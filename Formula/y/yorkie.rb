class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.27.tar.gz"
  sha256 "57d77a9c3cead214d0ca967ca57988c9d92ec44876704fb3af1ca4ca916dded0"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad674fe2a1002761afcd36f69a05f02dc8aa88442531e64d03d1b5f953b8edba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d3c399dea3da5e6bb82683b19723d38c1232a482bd74dda200119d0bd8415ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e51b3641bd516af1a53e06119ffdbcf63ff55bcb93f2e4a6a0885c3ba2802298"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "859213be608ca2664fadbdcd799c9a2162520fee542e0e24784eda0c5914a06b"
    sha256 cellar: :any,                 x86_64_linux:      "5ee17f3147a7ec582163ebbc0a6e4cee55b21a3a2b5e02ed32fb26d97b4aa44f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
