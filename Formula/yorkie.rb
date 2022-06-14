class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.7",
    revision: "d5a7dea64f9353510f95a396ae7cfab5d64a376a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3b2a6d732caec0f62a6016c556413cfcf75d8557206b2dc1f1fb372ec7b99b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c49c07f60be0dc206be65b22ad55f4f1d36a81a1f595a743070dfadfdec017f"
    sha256 cellar: :any_skip_relocation, monterey:       "42042d4c9ad8c82d7faf9121567dc9a21103493e5c4a7228c874c4f244a084e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "53da7827b4cee3d43891810430b668e188766152a2a5ab772592d9469a695a4f"
    sha256 cellar: :any_skip_relocation, catalina:       "f6dc1458f9e95aac7478e19a03a6a472af91400641125ee5d589c8c0cf6ea687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3696f64deb9c3d8fbabd2fbe76c6f0771dc09e2cc22a5390d05b3dd9e1528073"
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
