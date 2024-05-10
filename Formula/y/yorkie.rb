class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "26247ac7a0827e252844449794d77b87530a2da07ea375c8484c4ffc654c4287"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d99e332fd906662cda9bbf2bcc96505139aa03a450ce70303eae65c8add22c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "503f5aa8c9e974a67350fc8f3d232dd1a312b4ec7d9c5a3f52b28dee9fa62fbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4d560e7e6c4d4e9a315b9ee477633cbed33859346c9c23f82886fe40e77bc70"
    sha256 cellar: :any_skip_relocation, sonoma:         "74a404db3db18dea9888643590d02fff1b6fd6bee8d4db1dec2d3c20e948f692"
    sha256 cellar: :any_skip_relocation, ventura:        "d3bf56dbf6861521f0ae1d12083d3b3e80a546cf4a9b7a18728f56adadc9f3f4"
    sha256 cellar: :any_skip_relocation, monterey:       "828d047a7103c650e7f312934eddbb43e532c419b934a25b79d43a4dd85a09e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2760ded0e50ddb3c5346965732038ebaa7b79578e0da62cb8ecdf307cdae4097"
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
