class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.6.19.tar.gz"
  sha256 "bdd9d475e828e1271db653f9ff75bdb56b87b01b031ec16163d7afd9563aed43"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6f867f4522c3181466229d42beb86db07ecf056b191377a86ce02dfef4ad49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c265343c43ad8871d847b0c24598b9dd58083b1d43897b477d306e35d9bdf9da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97b912729661d335d2b53382bcf8e802082643443d53e4fcf6f7cce72d960a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad507ebfee6970bab0bdc870476d438a65c1170aed3e489bd25c5909911d8fb1"
    sha256 cellar: :any_skip_relocation, ventura:       "8f6b21968630ec77f4aff5c23dd04e87082524d5d450b43847f98a214112af2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f190aab96299263d62bf0f4ceda2f36d04cd6660dd5584d8bef0c4a378b262b2"
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
    yorkie_pid = spawn bin/"yorkie", "server"
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
