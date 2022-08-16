class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.16",
    revision: "b5321a49607ec6c52f7d46594cb7f16a0ebd41c9"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d08ebac9dcf38e66b119d23cd2b7cfd980e0f0d97f274d65db29c0f2dbd98667"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f699bc82a0c1feef8ab85cbb40f16837a49f7c9f04c2dc7b16c49af85ab160c"
    sha256 cellar: :any_skip_relocation, monterey:       "767fd30b3ba0ef4f2875fc0d5c2cc3e0ebe7e40387729a0bd3025a6d52c7ec52"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdd8d81c6d6ec09d460842b64bfb05038eb82d5bbdc169291b689184eb84ec3a"
    sha256 cellar: :any_skip_relocation, catalina:       "aac43fef3f9964a496cbde0df24be181d63d84428bee4c6e3f75e6e3c1969c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d45720c72660a513a56582cef4144f3a71832e8d67f07620d37719926c59951b"
  end

  # Doesn't build with latest go
  # See https://github.com/yorkie-team/yorkie/issues/378
  depends_on "go@1.18" => :build

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
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
