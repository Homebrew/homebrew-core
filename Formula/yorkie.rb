class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.11",
    revision: "33c4a6251d447366d0da49f7b3f60a05c8deceb4"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c94b46f903b8483f8590557c7dc975a5df554bab687699aa7ab77526b9f62ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a0a905aac8416d9b793939098369484246c7dc4669a57852c486113aefa3772"
    sha256 cellar: :any_skip_relocation, monterey:       "3f013d3b05a7036b895f42b40d2b785be4f225bb9d844e54924252c59a21587e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7265a143edb727b4688ac8ad666b6f6a6735a3f2806d6d434d347dcd1f82f75"
    sha256 cellar: :any_skip_relocation, catalina:       "6a2a13b177a049e352c2edb0b1d3bd7c45c16600275650a87ee6f4b8e933b1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d16b4c275cca08ff7592852f1a60455269bfba5c3f4da9de1ad2edcf5c53d01"
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
