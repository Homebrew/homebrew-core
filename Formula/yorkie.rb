class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.12",
    revision: "d25124e51efcfc23125cdbba9c231b11cd57cc7a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0564017004bedc76de37836103970da08f187bddfc2009955d56d9adb5dfb195"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd7347237e8dd57d7c7c06b72a4675ac89da56e76e4ad1199b6fb18dd4f5249d"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6e26c8483bb3df9a96d0ebb27ffaaf06dba7d0dfc8f2858b6fa9fb73e95d74"
    sha256 cellar: :any_skip_relocation, big_sur:        "b36b7181d95cbca42ff5440dd05f8a28a7cb651d89aa4a3d9d59bdda8ba0cd8a"
    sha256 cellar: :any_skip_relocation, catalina:       "cb2678d069979a267c73dbf1954399bc215a615c087fbfa0f81f1454de244507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "492596a423d8a42e4b20132ed92e7bdbd303fd803e331a1c3a341b4594cee82c"
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
