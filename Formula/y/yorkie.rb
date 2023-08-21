class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.5",
    revision: "1b557be51471337d3c6949d5f9ed5634b3a677e2"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5313b8aa6be605f7a303e1cca7707e2c3214e2f59a5473e7a346e2f2ad55c5de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d443433d5c5de4ac7413020870b4dcbfc1ee1f48dbe0e77fac386a9854d9640c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf61f8d26ece55d46153c0c1528e4b0cb4825781c2456c19d679c7a4f80615b1"
    sha256 cellar: :any_skip_relocation, ventura:        "a366a4d408528c3892b85d996d93044f328d1ddc256cbed89345126bca7d009a"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5d51e15463c279ffefe3ed6ac57c56748ca8ddeb3c7fe3b9faba300b164b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a4fc95537c0c0c2b35739bf1e7f77c03268f33477cac850db48d00b2ef00133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "992c71cdf1d367b5167b28c444db2da2e51caafbb146088e9d88d5cb2e72132d"
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
