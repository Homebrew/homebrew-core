class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.28.tar.gz"
  sha256 "df17438fa988bc74eb90141ca2b8350dce30dee816af02dc7e57195efe43906f"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05de11398f3946be3fe2c1b45701eec55907745e2627973620e1c86152c03e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05de11398f3946be3fe2c1b45701eec55907745e2627973620e1c86152c03e7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05de11398f3946be3fe2c1b45701eec55907745e2627973620e1c86152c03e7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9557ae996fdacd4078d0d9d03a539ee4df887231282ef589bda8b892fc871847"
    sha256 cellar: :any_skip_relocation, ventura:       "9557ae996fdacd4078d0d9d03a539ee4df887231282ef589bda8b892fc871847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6a6382772ef91686bd70f1b96646b3e6368fb29343c88f227f4fcfd8044e7d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
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
