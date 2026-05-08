class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "4b8a197a190d26ac6f999ee4779052257378eba4eac58393eba9248372547d87"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "237fc4ee398338223512dd8e9e1ca8101771d1fa533ed13deefaf50590629f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb19ab688334a7eb054a93ecaeec0d0a2207e80f0755f6184414242e04e0b8f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5d3180704fab2e76c32b10ab77836d3c13fb379cd7d99b3b8df3f8e860b6563"
    sha256 cellar: :any_skip_relocation, sonoma:        "44fde267aba01cb5ef6311ccde9d97957d0e335b72c3cc93d18d6c8752235e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56858c9a02d05850e20fe548deeb1bb6d86ad1b09fcebb59232b34f3b302c920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41dc75b9acc47905bf524b467257fe049f675acc5bc2e339ee63a65e97733ac3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/yorkie-team/yorkie/internal/version.Version=#{version}
      -X github.com/yorkie-team/yorkie/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/yorkie"

    generate_completions_from_executable(bin/"yorkie", shell_parameter_format: :cobra)
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
