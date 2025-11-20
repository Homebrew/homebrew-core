class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.39.tar.gz"
  sha256 "678a83b139a53419cb3c8b78f2485be5163735db8feceb389dc8d805373b5b67"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "988ca6454ab0c8b2439d4cb8c620ee6b4e08d1278de2caa3f91f57777cd73f19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988ca6454ab0c8b2439d4cb8c620ee6b4e08d1278de2caa3f91f57777cd73f19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "988ca6454ab0c8b2439d4cb8c620ee6b4e08d1278de2caa3f91f57777cd73f19"
    sha256 cellar: :any_skip_relocation, sonoma:        "b24811689cb65bed48c3a8650e588776410e2115a908dd9e743d66bf1248ca71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227a8b552f721d467d0e49996cb7c3ae9d415859523147ebfa907ee59a3f0a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907ffb967a6fda6e4035fe3ecb10ac62b2b7227a1832163de038e1d2904421f9"
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
