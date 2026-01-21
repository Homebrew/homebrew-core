class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.44.tar.gz"
  sha256 "2716cc8eafb997375b7c970e7ae02d59d48d5b044ed168b01bd5aef7aef61e17"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21778ea4b07ced092aed7d4b25c3a24b3b592aee64452b4e6e3d5f2d06c9ba6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95f682d9665f11f5c39006ebc5c2c5c8b07126de43c8485302b0ddbc44bc6c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42952ccb108594dfe92f7ae7ce7d12fff1a09a90b4bad3eb8d88e4ec411dd781"
    sha256 cellar: :any_skip_relocation, sonoma:        "d251765fb88f7f915e07c056c5dbb4434ea1867d203b567f79e0acbfc2c03df4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16fa24ad84528c5238bd1c1ca389bc258a7bd3370234a1a1a66d71d6d9692920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969640163acffa7019c2a6c44df2d4a55bd80a11da0415a7112975f272f2d9a2"
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
