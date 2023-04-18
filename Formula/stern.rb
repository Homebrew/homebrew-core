class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.25.0.tar.gz"
  sha256 "9742fa8d9c4b75bf0b261c42996d26c0f706400c043f3f83d159238326c717ea"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d5ba050de4ea6e10111f5c8a25b9097d5eac58d3cdeb989b05332511878fe19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1bbb023fffc3bcac63826e86c983bf81e1243c5d2f336602c6c202fbda7dec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7de5023ab4f241c2736fe0dbe898d682724d4f599f59412ca589ec0a3b91e86e"
    sha256 cellar: :any_skip_relocation, ventura:        "b310aca298169454b74d492069e3669034def0eda58d5bf1e8dbcf2263bb3736"
    sha256 cellar: :any_skip_relocation, monterey:       "e7613bf2a508febed107928edeefe78e5ab9fde666ccb5c974065348f9228dea"
    sha256 cellar: :any_skip_relocation, big_sur:        "6daeaf2ca920f987afbdfab2af6354704593a974e11b7b869c3559afc714e198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1f91547ac37e1567e8d4bd10150878295dd96f4efcf350211ffb0e2a3d170c4"
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
