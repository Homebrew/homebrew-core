class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.16.tar.gz"
  sha256 "506b53442cbaa3ea34990f182d2db206d6987d7ae3652f91883ab6358af6b2ee"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88519e6f165f13660228652a61851167a91ed5cbb901ea4a2ba2a9402840e684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88519e6f165f13660228652a61851167a91ed5cbb901ea4a2ba2a9402840e684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88519e6f165f13660228652a61851167a91ed5cbb901ea4a2ba2a9402840e684"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4986ed2a2ea9faea4ac89f6f2c69135f1c98cc6fb91db9686098df15c3c68df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df409811de49059cd385206b56afa0f54dd5327a782fd710cce584742386c529"
    sha256 cellar: :any,                 x86_64_linux:  "90701026c785f4557e7f367ce26bd7b160dfdd3f92ac00268ed141980bae64dc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
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
