class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.26.tar.gz"
  sha256 "091130b3ef37a6531e1441ae14bbf956e5cceaa77298df01acca2772f67ae266"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "768110948e756231e238d0a36229d3208e160a0ccce3289c234541a7b90ffbc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee8c6baa0514d244b5b965265552fbebd5084ab65228d22987f91aa7218f12f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9ce188e39d844cbec28f26dfa5194301a3a9a72ecbb7b96260c9eb00777a617"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fff94cb570f21d400810189a994415dabe13f56adcf9ab62cf450769749b564b"
    sha256 cellar: :any,                 x86_64_linux:      "a451957fe4647247019170f50c517c2fd5d3963d75f9983435e760ea31050b6e"
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
