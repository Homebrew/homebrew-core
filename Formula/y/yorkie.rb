class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.39.tar.gz"
  sha256 "54482dcc23e24940286dc50d23c2b813b5b0d0826362fb8832b48d53104b69d5"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b173c29128143b51a17a196c096cb18c172463cbd9f2f5c3eef714be463bb9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e60ad51808debb0d8312c2428a1456e3c643aa8b82ff72d866023b7f9afa59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68fdf22fda20058ee3c2d1a3ddf23d63de37a77de1edbca94c4b9fbe67e4809c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2afd8c1ed1bf04a284395d261e7f922c29c0c7153c0475a974f4989bfb13408e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ce952aa81a5a097b804373efd60cbc99d486a160e37fa0e9dc2703454de78c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c15406fea220eb292cc53425503d0b189f11a332773e9da51cbd8723244a264c"
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
