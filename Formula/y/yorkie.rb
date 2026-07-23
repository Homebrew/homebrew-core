class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "1d35975f862b814554024eac5976e49dacc480e46ee2a834e934c40b858c4c93"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22f571ed344d1f1d36d8da3dcdf192a75f34954666762a156e2158070fa5f7b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66dba7f5814769215e526e11c1b6564e3abca25e15a380e9d982b6c17cc7e7ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1629786d97c6dace41812b33adaebc6ff5d9e54f87dd80ea4d79999e8638bd96"
    sha256 cellar: :any_skip_relocation, sonoma:        "563c41dcdf66d7eda9e1f41e126f6725bb0322322acbfbcd67007b368e520e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3217a05cfe63085c9330764ef8cb6eecddb50a63f39c74babe48b99d4ac8f65c"
    sha256 cellar: :any,                 x86_64_linux:  "dd044dc640104f18c9651c32f4356f1bab30cdf12f803d10cb72cd5b8e7270e0"
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
