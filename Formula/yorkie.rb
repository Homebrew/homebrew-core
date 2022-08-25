class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.17",
    revision: "109ed36d485c92f123186e5e704a3946ca6c7db6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3347f51efceb0a6b54a4abd9e9e4c9af38804ba61cd695fcea1f2b4f0a3d72f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a9459dea7d576e5a71b232c0cbb3a591a14e638196bf27634f5b6fe74407ce9"
    sha256 cellar: :any_skip_relocation, monterey:       "d1fa1c50ccf0af19f4f46ba76ab27d779aa4f60169beb3c3706fdf60fce85dd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbc1ce5e5dd831eaff66aca1acf37101786f64f942bfe8b51ec828dabec1fa9d"
    sha256 cellar: :any_skip_relocation, catalina:       "5f1c4752b90bda4cdb6065ba40ff9bb14501584a33e3eadf55d170406d92ee5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db807b8b9f8e83b62e176ec2da0c7787830f4644b401151903e330c249314315"
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
