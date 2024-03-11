class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.15",
    revision: "eadb194a7aae85bd41d60b9619c8689d41599bee"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0753829640d7d40020c218be7f411ffcb3c4b0f1587c8c5a3499eeb2033edabb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "837b91eae9a1e40f5b4103b74411c07da2c43c9dc0635cd0eb48226359ca08bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df138e40455367b849faaa711bc29070f1283fcee6fc53c0844e4f25900d5efe"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c4476bb965251dd9bb54f8ddc32a814798a2b9e17cc53e4e1cd14e7463b8e73"
    sha256 cellar: :any_skip_relocation, ventura:        "fd8e8a88607ab089f76c05ecdc50f00b7dfaeb9669d0f7a55cbc5da34215b155"
    sha256 cellar: :any_skip_relocation, monterey:       "9487ecd172fd7df7549d9a76f400fe161e63bcc8ecdc5de7d46735c3cde58400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96982e91f246374a9542d739622861d1afc4397750d261b01fe0e4c596e2be1d"
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
