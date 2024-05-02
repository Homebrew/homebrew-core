class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.4.18.tar.gz"
  sha256 "5f3a4fbafde7d0b4692ebd932d85ddc47d70c733fc797e2a919d8b061cee1aa0"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28e516fc6dc1071dee9b7a23bb8254bad7ef51d9ec1544f3a1b4f50fdbe61a49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eb9a64b1a84bdc59c603cfce959c518d85125904a4dd9a45f481409974c043e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a21bc0acd31a6b6cfaed14b980cd127e6de2ba02f9d1fb00ec8502ed9e619d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa98ad9e7225f44f677448f520cf6776c6bc699440ece32b62ee783f999dfefd"
    sha256 cellar: :any_skip_relocation, ventura:        "eb01c1bcd5efdee2495eff2f9fb1523e57fabb37d73697259a51ac9fbd8537a6"
    sha256 cellar: :any_skip_relocation, monterey:       "a8ed4e78a59932ebc5b3f59f072c0a80cb0434f55d63870d6047fb3b764b568c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95fab9db115325d7f43c152c5839ad3ce22c2904e2952a2c55e4276fd52e5ef"
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
