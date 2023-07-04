class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.4",
    revision: "ba89b2cec605cda365df1ba943e8cd41154c7001"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ccd343ebd36985d4ed6d047be1daefa8db33f1478af2f1229e621c90f73312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b3e1368edffae58cb3530a8ea92294de07b252b2abb3ed0314535a20093806a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64422e4e5ab25d81a37456e1070e823b8bdcf7e98388c0b9f3b26e6d38ebb5d7"
    sha256 cellar: :any_skip_relocation, ventura:        "9294f687477b269b4ad7a174cfbee90282ffccbd5f3322e0eeeb01ab16c8cfe5"
    sha256 cellar: :any_skip_relocation, monterey:       "61001497060bc080c1374b65cbcc5be5872844d5e637d46211be31484e8711ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc28b434485629c048fa10763ac1f1b997ddabbd0b7159f827facd81dc435e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "237ceb0756a7cb8dacf88354cdf73922dffc4a198fdc208191622234716f001d"
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
    output = shell_output("#{bin}/yorkie project create #{test_project} --insecure 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end
