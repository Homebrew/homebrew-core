class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.17.tar.gz"
  sha256 "78e9ec30524f4def9aa5b5e50861cbc8c7e9d9f69f0bd3a5690270b4b74606b6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dff2fa80a26eb80cfa60a84bc79e593147c9a7e0d63b2419aed931d65c2d9ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aead48dc8cd0d496f2ab73650398c271b7e205d97ed92def3a4cd55fde71cf8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af1cc244cfff64966dc6afa1a82de7f420acf296e470f0d996c066566fcea5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b337f51e7f6996044399eef08d90f547fca75594b08e74de8c5a8918ba872b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dee5d3015043c24cd405b72507a9bca986b19796800317e3993415c77e06c351"
    sha256 cellar: :any,                 x86_64_linux:  "bb7f671d065c1061efa45d6f1fccc0e4025496fdd7c81dbc7d9469a2ffafa4ea"
  end

  depends_on "go" => :build

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
