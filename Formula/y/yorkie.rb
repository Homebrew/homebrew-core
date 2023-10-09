class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.7",
    revision: "aac916faf8ad7dd61958e0bfd829f20669771c1e"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64e1ce20f176ff37f7a2b51f3af4008a812cec9e527708cd77fd2d4254e906dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb6c024bb657fa00776a59fcce8c30c86c08fd0c93ccc62efff53ecd1d423592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030a43aeec303bb1261b23cf8c2a454ff6614477bebd0d91b5354983bad1c883"
    sha256 cellar: :any_skip_relocation, sonoma:         "535eb94760451b1c94d1c613d14ae01eb54808e31bed5da4163b8fc13013d6f4"
    sha256 cellar: :any_skip_relocation, ventura:        "f4a6adb0f1274e0b89fd536ff98dc7c7b1812ddd271f629f520fd04f09919476"
    sha256 cellar: :any_skip_relocation, monterey:       "165451a13998f01dfe634ea6dd61b55cf7c7f74b7b2df585a1c5a4608933e002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d55212e7aaf21619c968aa3215ec43ae28db100a4f8a72b6fb865a9606009c7"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

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
