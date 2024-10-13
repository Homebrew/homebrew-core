class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c442f4cae0e179d25772cda77960943eff3acf458d65cd03df430a7d34720d6e"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ab9bb5c5a647b026dd790808cee4d8b52c889f922d8e0dae638fcbd3cdca32c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27c1a2df71f3b6ff1a3603a3016c1aafbf73ff42e876113a171b19d993639b60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27c1a2df71f3b6ff1a3603a3016c1aafbf73ff42e876113a171b19d993639b60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27c1a2df71f3b6ff1a3603a3016c1aafbf73ff42e876113a171b19d993639b60"
    sha256 cellar: :any_skip_relocation, sonoma:         "56ef53bda6cc9e6078b88c53b0faafa46c268716d61a082f31f873e14d0251a3"
    sha256 cellar: :any_skip_relocation, ventura:        "56ef53bda6cc9e6078b88c53b0faafa46c268716d61a082f31f873e14d0251a3"
    sha256 cellar: :any_skip_relocation, monterey:       "56ef53bda6cc9e6078b88c53b0faafa46c268716d61a082f31f873e14d0251a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c1ef0324e1132017576e230f2770b337102dae9522ce90d94793849b0ef1cab"
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
