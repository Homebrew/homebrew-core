class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "f432b97d7a2f77a253df44f6c07830e6c7bd5ee59a9f7121c765e2cfc2b43931"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac2d9c015d3a54eb7093d84020cccdb4f5aec4105907c0cc3534c20d32702852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac2d9c015d3a54eb7093d84020cccdb4f5aec4105907c0cc3534c20d32702852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac2d9c015d3a54eb7093d84020cccdb4f5aec4105907c0cc3534c20d32702852"
    sha256 cellar: :any_skip_relocation, sonoma:        "31132910755db088a5f96cb879ee051d287dde67091d4d3ef5eae2bc81cf82fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffc25d6205943bc3cc2100bccb550ab13d29127df5d206bb65a9d84937ee275e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34cea34622a90bfa810798f6995937e67a7ea8a54559da1de4b34bfb8b7e4b44"
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
