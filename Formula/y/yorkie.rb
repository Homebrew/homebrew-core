class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "ef97ff42062509fd42ae8868ab969d53df2fae759456432572342759b0cf17b1"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9803d2f816b700d01a701af234896e7ef0ff37ec78d2a04ec32546f58f21e649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9803d2f816b700d01a701af234896e7ef0ff37ec78d2a04ec32546f58f21e649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9803d2f816b700d01a701af234896e7ef0ff37ec78d2a04ec32546f58f21e649"
    sha256 cellar: :any_skip_relocation, sonoma:        "0263a8f5b42fbff2c864cc3bd284378f4d9bae130e13571b9a1248c88fa20055"
    sha256 cellar: :any_skip_relocation, ventura:       "0263a8f5b42fbff2c864cc3bd284378f4d9bae130e13571b9a1248c88fa20055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334d403fd80f52283726622e9ce20e76087d3b18c4f61df18ac1dc67d0d3ead1"
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
