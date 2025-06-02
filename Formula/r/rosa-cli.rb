class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.53.tar.gz"
  sha256 "4352b72f94d22d3a29aa20b4793c19472ca3c1ba1c689676bb37f8c7a453ecf6"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9796c06d7d1710c41b9b140b944baedf306184b6957e0ba0743dbd343038f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10c1b00979c0ddc77a0f4d71f752a4a6bc008ff7c7892ce5c87390c01d78795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8c745e93305763691ec054ec9c265d93d8a0d88b2753d86f55daa8a7535411d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4144c78301080388ca575123c69ebd7f482ac4c38916aabe83ee5a7cd811da4"
    sha256 cellar: :any_skip_relocation, ventura:       "1a1fef6f4d55fa55e3e65271f4deaec59749a64ab8bee65f93c0a7cc6ffeab6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639d242acb3115c00b14cfcfc3f21985ee91507d60f5168c2c4c21a3b8ede986"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
