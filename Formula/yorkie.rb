class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.8",
    revision: "aea03043b2d62691bf8c9c26dc3dcb804b87381a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fd95bb16debc53da3d8480decbdfcdb1586a260517bb33483813c260d8bb620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8a7b1e1471cf5f9b839e720b6016df1594f54997762db58d7ee92a4c8724f55"
    sha256 cellar: :any_skip_relocation, monterey:       "76d4ebbe6bbbb4d7df62549f67a4cf72b871758685d2bebf8cfd14ecc709db61"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7ec800619f23c27fa09e4edd654c78d4ffd5c367a5d72092e4fbb14b32d9c6c"
    sha256 cellar: :any_skip_relocation, catalina:       "b681897f7e2453120c0507bbd972530e3aaadfd1572f99f2c25ba1b68f620aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f250ea01741aad0f561351db76d61c7a91732dde70578365c48427b0390e0d69"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"
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

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
