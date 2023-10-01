class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.26.0.tar.gz"
  sha256 "1caf2a6f1492f763bb6a961d4c8af8cd3ab1952d216b0ab21059fe1a1d4426db"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d8e7897c385185f4c3eb10ae3b73e82a0d3922c989eb1833672636eb6864034"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "484a069bddba5e729d026cb5cc30cd1c3044ab024bfb2d5c713a24b2e50026a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6483cdf23b31bf38e7b16f5f251d2788612c2ea68113ac58959df978a82aa4d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72cd77054e851ebda6cb6c8046fdf768326d7356f6717342b8ef6fbaedf56cef"
    sha256 cellar: :any_skip_relocation, sonoma:         "75a76757081e0028ed3169f4657f76e79445f192e27c8c00632b2a220ec42207"
    sha256 cellar: :any_skip_relocation, ventura:        "74a733462052b5af3e2c998482d1bd15c4fc8d95cb311d9f6065c79f418c5a26"
    sha256 cellar: :any_skip_relocation, monterey:       "da0c26a22154ceeea5428d7fa2405c779bc43be39ab9a48bda13c1d5636787f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "34e615a98b044b463c00bc11efac67f8eb1f53b065473c2a002a239e0b2dbecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164b0c3ae1ab177ddf011f2b9d2f2f7868b1be031eacf902802702aba9f61d70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
