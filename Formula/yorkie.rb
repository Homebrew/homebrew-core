class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.3.0",
    revision: "7635b73a236d86133ca6bfdf2e687e3dae9877e2"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f82c3f28a519044b973b8b0720673a60c64e20097e7e8de6ae88c9744c50ce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f696e8636b9e7e12c06e11959b962d6e7343d69d76ffd3f35e2160080004cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ad28fae23402436e089d3ca68f6150a51d7825f6a9d4774a3cadeb2f8b26abf"
    sha256 cellar: :any_skip_relocation, ventura:        "948328b9290ecdd63a442bd60a396c6e0f32c78f60f860e055cec007951e30d7"
    sha256 cellar: :any_skip_relocation, monterey:       "2f1f173a99a76fc97afe3fcaed7e7130fd8e20a3eaaf4b3de3920bea2b333d7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f71f4007dde961edeb0cd64f6bdd2dfb5d71d92cc7370979e63f3daa3ef3ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b1f5b34048443b6d8b4599a49eb77baef30c47bdfa08f2ee8d65e9104c9d8d7"
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
