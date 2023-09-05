class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.6",
    revision: "0817ad989d0450d7f681fa904cdb07498edaab42"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40b5e511e0ba8daf2c2482f5d58760cada1d8016995762e300a28ce740c64e2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "771f90ba899bcfc8e953aa3c89cb32dfe089c0895c75600f2aca4a0472369d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea3cbc558ef48724cdcbcda80131228c14310b2711db6c0b3e31b97573e01782"
    sha256 cellar: :any_skip_relocation, ventura:        "18ceca2ee33c19ca6c0bdff05d46485dc3f25ce7eb04f74b34b9698087c84b65"
    sha256 cellar: :any_skip_relocation, monterey:       "29220213ef2ed25c6d0376fcd51ba58e0cccf444bc13fd9e004e676583ead3b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c37cdd7a1c23b1e151cbac8cc7c5c4b32b13a17b4a01c00ab5e50a5e5c5a8052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8b399ff482672dccb0dc67c35f51a04d61b19a920e302dbb332d1b927bb717"
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
