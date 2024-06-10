class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "32b5bbddfc206d7ededbe0a630aa82b1437d118586e005ca6e48908718f4a6e3"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abf4ed59724ff54dd1d796129b52c16d66b38197f7ad849bcf95fd0a87fcfb28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187cdf27622cff0242ac8dcb1b5abb42efd8b9fa324b16bdfb680bb844d1d920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ac2433417073064c4a254760171dff08814339e04a5b6a09114e7ba0fcb1fd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf1c4c73ed46e635e7a21d22c2e6c5380fab3e8f35a1d262e670094d05c9893e"
    sha256 cellar: :any_skip_relocation, ventura:        "ce628bc2cc3f0a56bb8934cbb02e8db7b9eefe1d503a65f947d68d4bd411ad8b"
    sha256 cellar: :any_skip_relocation, monterey:       "378bb38ddb024ce223c750ebe21b9da13bc20b5ec458fcb004b5875278e1efc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8dcc984ffb900a67e4dde9e9b83016199d4f61dbbaf5e191f630127c25457ab"
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
