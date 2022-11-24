class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.17",
    revision: "109ed36d485c92f123186e5e704a3946ca6c7db6"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e356a9e3d6a9f6cbe57e280d9b7d2d08150d4dd8852deab01d8ceb4cfbcc5295"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7a4081156475a734c651d2a9a973c3d7ecc135ab077d89a6f462dbdd08f244"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "973028571c223bb3611ef3c741607f738b0ea16674ad86d4f5953449946adc00"
    sha256 cellar: :any_skip_relocation, monterey:       "901fd50030502a777f11a080a5685bc43bb9a8665bbf1084f2bf78d95186e63d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4aef6656f81f160c674dbfc27c400d769219e06084b7a28e4e5ff0f4504fc89"
    sha256 cellar: :any_skip_relocation, catalina:       "a571188c75a6096778538f19013ee0241f4ac67ae9f46474d012f30f9448e37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5f1e94138547d446c4e4b545ad4cbe494def6dce4634f7986646f3f7e8cb41"
  end

  # Doesn't build with latest go
  # See https://github.com/yorkie-team/yorkie/issues/378
  depends_on "go@1.18" => :build

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
    output = shell_output("#{bin}/yorkie project create #{test_project}")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
