class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.2",
    revision: "dcea8c4666b4da149292f3da2e5b731d6416cd28"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbbf79ba9354208e9e46be7ed4386bc4df19c7ed6197764a2d64d3ca122e82ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf258322dcca43f646a1eb40e56af348a7fa793e9324204f42d8d33dcaaf216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12046ef6d5242b026e3b9d94df95c365c5b645b490a68bdf1c21dc302ae70c72"
    sha256 cellar: :any_skip_relocation, ventura:        "1a7d99598034a2f93a2e41c9cbeceb5739a51ec5cc90eb94c1e1df54fb3220be"
    sha256 cellar: :any_skip_relocation, monterey:       "9a7531a7c58e856d37c5b43bdbaf637e70e480fd666307cbfb7a31b551b1050c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bbfcf58b5cdf60e53c511b9e23f54d81de9dfe022db99bc34249b2bbfed5183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3b158480109046f98cdc44dc7ea63332601b0b5c8062c83346c48b1c8a0f58c"
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
    output = shell_output("#{bin}/yorkie project create #{test_project} --insecure 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
