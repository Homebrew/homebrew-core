class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.1",
    revision: "0ce364b62d487aa1a6cc26f059f3eb6cfefb19eb"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47cafa8fba6a889655511b7a6ac9cd763e8fd1466827996123b51e651725b6ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5488e9cba7d6d75d3b381d0f53addb701e275e9b4688a878015e524fbed7b586"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "969d417d35bb2c1b5f003fa3965a1867f29ecebf30134c863d75a5007b1ecc26"
    sha256 cellar: :any_skip_relocation, ventura:        "5ea70dc2c5ae22dd1579ec30969a70a8bf414ae23fafccb337f7d43d598f9086"
    sha256 cellar: :any_skip_relocation, monterey:       "0fcc75362c261ed8d1f5959446b6673a74849e643dea08905a2948f3311c4820"
    sha256 cellar: :any_skip_relocation, big_sur:        "de2985c72af37955e8fd37bc9bc8d1918e7ad8e1fb4bbb4fea2c83dc747b5701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec1058c0565f83523753f18535ff43264c85889e43b4bcacbc81e4b5588f848"
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
