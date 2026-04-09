class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "cb0d7849b6010688540cb5671ef24a13f1576f61c8940ac415dfa830949bc17d"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36ac0ffeba0bb63064c6a6b40bb47677c78d3ef61d9dc6b05ed4ea527db8e096"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19012b44bd68a338ad3cefbc3dc6fbe05bd9600a68b20668c5d6daf50ead06b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e9e979e0c0276e80c0161f20bae45fd46554d13e4ceecdd5545b44970fcb064"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e1cdb435da1bc723e76de13948e7752835da64f5f2209fbc7e6be62abd6aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429546e9f2f476e66604e1bf62d09c518a19fd9da39e45506e0386a1c5485399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8616947ff60b6a0cfcd7f5476a143640738252e7ae2f2cf6692b825980cbb9b6"
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
