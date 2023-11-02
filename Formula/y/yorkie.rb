class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.8",
    revision: "f922afcdc28c3dc80d7b73dd569ce3f2a696016d"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7515295259ea1e2255356106838db68299723a939f7eb7880dec4621e6aa158e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c520d4a63bee4248c929c6a3a0aa9c5e47e85ef0e76c19d7edf51349e6c6d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337a1f1d926d4700b14b49f50b986c952cd67a1f21d17893daf1098521696c1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "78f29041ae4437e9c1c3a39bae8973ffaa4d36fee80ea5209ee0fc6e4e537eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "1dfdc3a83328013e47a77fcc11a91b857cdc94a43265cca496ba1774780025da"
    sha256 cellar: :any_skip_relocation, monterey:       "bde24b22e5622f20ac07493c75d23cb15dd111177a1f7e3b2a3f67ba5af94df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc8d82ae5bf1a7e3cec7f1157fb15365ee4f31fb103a21f6fa0bdb9dc268d05"
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
