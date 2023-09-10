class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "73f563c0f8a97c5d1a3efc0af34f8233beaeb52cfe2b74f69da237b5b4f207bd"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b51a76aef02ea29009fa063bd91d4256cd91b419a8459862b8459e06e0c9b08a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5bf4a6e2e7de06533fa6c3b6323e195193191ac4cd2f5717b2055656ee7902"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7810528698f8cb84e5682e7421b2c3820974d8dc4388d52cc10baf2d893d15b"
    sha256 cellar: :any_skip_relocation, ventura:        "3024d3672bf8dcc332df700616dbe82270de9015f8474fb3b49b2fbc39a64832"
    sha256 cellar: :any_skip_relocation, monterey:       "ed05ae991a6d957b86f471b83ba836de239967bec58c581990ec0060611e5a2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd8972b923c2ab170fcb47d9e9e5ff84a08237c02cb915a78863eb419c88a7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "133b093d0121db182266ff3c47caeaf293d68eb53c7a756706a9d47c4907958d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to decrypt/read env file talenv.yaml", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
