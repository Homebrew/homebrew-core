class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.29.tar.gz"
  sha256 "03d4ffeb2e3bee84df31536d67fe669c530f79e485976f8f02b43576cf3ae33b"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "a6216bc7011d0d69c281b4d9f1cc8764a7cb0dcade03f2582f01553b88b3b802"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e66047d1321a5acf5a47ba139a83c12f23bf97aeebcee389f4663539fc7962ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7497947e381e22ccba0011b217b993e5f421bc375a1f08a0aaefb3d52e2297d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4dec23aced5dfa98a8a93d3db721fc52389c5ce45c8276cc9bc87b4b16780fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c64161d46c0569e20efa511ea569a606e5b1ef18e936ef23eee55c1cfe1ca6b"
    sha256 cellar: :any,                 x86_64_linux:      "da3f8bdeda5ac6bbeaacd6a1934353ffffea499057912dbda8337ebababef7e8"
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
