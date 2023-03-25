class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.3.3",
    revision: "fdd62a95e802073584e861e1e305f93b24a53d8b"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b458518e2dfd2e80911563fd20b5bfac40a833b1edfce78b008a97d0bc7d0638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "007c69907c1c27672b373e7669c74c380b2be9f4d8989ae6dbe25dbb826428a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07f7d05d3d14f4452f6dc76bb032f5c59ca853be5cb2dc64deb57796af93af0f"
    sha256 cellar: :any_skip_relocation, ventura:        "c279caac6aee34c2931483df5d04e545ff4cb9e115a60174f5ff4ebb5c486e14"
    sha256 cellar: :any_skip_relocation, monterey:       "7ca49972fc55e60c62a93f9189709e4c9be69f68ef23133abd88ae08fba8f187"
    sha256 cellar: :any_skip_relocation, big_sur:        "2045b84b4a17a351a316f21214a5e2c12257feea01a0b9dd61aebac73fb5a303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c69c4df8ec73cd1173e0d40fad52906900084c026fd1b9b409fdbd2f3067c677"
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
