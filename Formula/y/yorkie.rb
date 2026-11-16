class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.28.tar.gz"
  sha256 "37f8d0945699786d34e2ee594c5b99b3fe3b63243354285fb29e0be08ae7dadb"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aba4e916cd50a006a2bcb4ab03abbc08fc1a7d45ae24a0e0188f651801c1ec2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66fd0014ab54ec1723804073f300c016a394141a3b6438e369187f7ce9fb75f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a106e42a1b8b5f52e65c65b16e0b609dc1e5a618465ffdd5e71f576001c6e567"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e5a1134723cc841f015e6684c32d7d8e82765f004d10c51c20c56f572bdbc4dd"
    sha256 cellar: :any,                 x86_64_linux:      "f7f736b5f53a901035db3b6a7aca7e877d452bb587bc36383176d8f205055a44"
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
