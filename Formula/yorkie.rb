class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.2.20",
    revision: "3d77c98d7fecc611c9c9a31dcc3ce6c41da81232"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e9437253ef6148299c0fbec3af66b668c708700339e7858bee980396be4397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1527acc978bb5df24ffbec6cfc525b9d27cb4bfae15a6e6a04570838f32b51b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f7e0a367f385e9066c28772983245b97f716b79940114883f8bd9df61a7fb51"
    sha256 cellar: :any_skip_relocation, ventura:        "74b1ab78a43fdba697cd5aa24e9aa18295a232ec4da6d62773cd5df2b935f5d8"
    sha256 cellar: :any_skip_relocation, monterey:       "daa8c0201f1a88772b03bbf18593633d6fa24769a91bcfbee239fe278f237288"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f4124c587887c68a5c2b397986e482789be094e8979496010bd0cc4d9f037e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff5eaa9e51f2951b4ac7beddbddf941bd403e32fe965a5b7d35a7d4e2ae3675"
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
