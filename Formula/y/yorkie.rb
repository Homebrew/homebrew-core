class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.4.30.tar.gz"
  sha256 "c9af27f813419ab51acc1e8a7fa1b52f3d179de776eba19ffc809d690953add5"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a53a7ef1689e14fb26027d847d4830f9b86d77a46b0aea83ca3525b9fcbbb71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53a735a82d3a54be34528bcea74af60598aa03609287c3c6060ae9b8bc902b62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5720843fb587d48d9c00c8f2ac157c87220e812ca7b266e0e402a8d14c162b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0b3349986dc5240d3fd9b0f56289cf9af902b223396d451f7b17747d2b7e412"
    sha256 cellar: :any_skip_relocation, ventura:        "a4f11d4f78826e1b8392f7fec7f2db476131050d88dcfecd3ffdf3dba38392f4"
    sha256 cellar: :any_skip_relocation, monterey:       "df752a6702f7ef0811c45483814c8f9d29e0e82881430c5f1ab6df53a58dbdd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313572498d7fb8c71006265c7f091b3837f72f90634879034c3c85c7cb9dcca3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

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
