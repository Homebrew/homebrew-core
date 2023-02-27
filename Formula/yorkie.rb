class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.3.1",
    revision: "101df332f1c4f6fd95e9e8828aeeae44631fcf31"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e5567a2133f3c302d33e1767938985b9bf2e5dbea353553806149f59d9e8dab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "738ea5ad33ad3bb0006580b81c19dcce542dcf73a70095a5e2450dada5590967"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b83e186f479acd70cf84669d2d35c3512f88bcbd5249e0bcad3069321bbefdf"
    sha256 cellar: :any_skip_relocation, ventura:        "22a24c4f136b1302a01b9528a6a54a8f10a51f5a0b4f9bc95dfceaeee71f8454"
    sha256 cellar: :any_skip_relocation, monterey:       "010a12d1ce0df1dc83405e81ad39bebe99d7f4ce9df92321495468a622973047"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d909833b70e2480e931c954ae39894ebec21f326292a090a18bf607b215d0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d3c01925575883add99aaaf608cd53805a7fe4e3704f025c0962d6ca9339a85"
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
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
