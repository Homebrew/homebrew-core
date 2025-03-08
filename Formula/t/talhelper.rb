class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.20.tar.gz"
  sha256 "bb2d51fc7dc0d0991a4193d53f07b64f302ea03f9b0f30c936edce082afa1baf"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "377e436c0341a63c69e33b76699a0ebe8343963b14ee5d8b5a28ebf7fe3a6414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377e436c0341a63c69e33b76699a0ebe8343963b14ee5d8b5a28ebf7fe3a6414"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "377e436c0341a63c69e33b76699a0ebe8343963b14ee5d8b5a28ebf7fe3a6414"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e6ed0bf369621f926808587cee2ce36c45ca31267d9e6dd005e775e79ceff89"
    sha256 cellar: :any_skip_relocation, ventura:       "1e6ed0bf369621f926808587cee2ce36c45ca31267d9e6dd005e775e79ceff89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ce760ff2e7c72e4a2ad61c990f664924efbaa2a74d7f65d5bd3f7fe7fffc6f"
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
