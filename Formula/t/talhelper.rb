class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "149613a2b25572ca17bcbce4cf58da00ffdfa237c07d3947ca894afdf2e3df0c"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98d8dcf27cd94539390b7af847cca6bce149621f22280a3ac11f93331d8a0579"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293124507935cff822fcb1ffaf099628a83042220974666c29cdfb3825ccb0e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89331941f66596ff8af171d3057160f61de1ff86f1bb7317816230108bb7b3cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a28e3a10903db7e745978a20853ccba0197818b4501f5e88fd643be5d55228d"
    sha256 cellar: :any_skip_relocation, ventura:        "a545dd6f4c173f2d14a0c462c91d24865c95c8db05d712f642d643f39e1318d0"
    sha256 cellar: :any_skip_relocation, monterey:       "e02ce6f2e8ff167f5129339eb6e5da874fcc4784ce0bee9d224009d8afc65451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51fedb9610171e32d03c85b389435376fc2320f232a320f9cee1babbd7bd27f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
