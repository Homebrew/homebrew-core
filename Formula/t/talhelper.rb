class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.12.tar.gz"
  sha256 "7a219f444b5b56c0839bdd833090c8b90c29cb68953e02ffa153157a26d57c3f"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f06ff9f50624a90e884ca9882054a35e554c6b6bc392313b051255afa468a9b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f06ff9f50624a90e884ca9882054a35e554c6b6bc392313b051255afa468a9b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f06ff9f50624a90e884ca9882054a35e554c6b6bc392313b051255afa468a9b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "528df38d3aba1dbcee0e048788e3ad07a216107005cb9a153d4b1fac017f0294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f45b2b8fc0e4da9f6ed26fc4728ffd9756413e45dd6e2ae13f7ac2f102c19cdd"
    sha256 cellar: :any,                 x86_64_linux:  "bc6482f6423fc3f9450eee146b67cca78d835ba022e045a830eb93904402b080"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
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
