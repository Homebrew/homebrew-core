class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.3.4",
    revision: "0b9f994459380e44deea211790bb8357acc97776"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f6c2b9a2a71f175cd4df317ded3c5c68ec17ed018f8c6a1aca2a23eacb3bf44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41f8c321e590ca4784fb7c5e280397209c2db5fe300b9ae42c073e0e4a9291cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a4188b91299d776e04c5b434d992aa9aaf19eb7c30f929fb1ffb6ae7fbcca5c"
    sha256 cellar: :any_skip_relocation, ventura:        "79ca8ce890b3b2b3197ce404f626151ccb3fb9e34d896e2f2464564100cacc3c"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf548b05857e7590354411764a9f6fcbfc8902537c5d9e3d9aebe32d8abab8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6843ef8fed0242c2069a3e3e47a6003ef910e3ddeb4cf7d56ae721abc8f90d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0ef65e5452802fe95e5d869ed439e4de54f2de5bef3c60d78ea95c7e0dd03d7"
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
