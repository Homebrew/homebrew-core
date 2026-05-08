class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "e52d3863198f917bac2f1ce607ce6bc41df4a590c5d23aaba7f234cc0bbea5c8"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "652eba87446f139ce23b456af14e00a15ea368e07bb314f926816d3440a95bac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "652eba87446f139ce23b456af14e00a15ea368e07bb314f926816d3440a95bac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652eba87446f139ce23b456af14e00a15ea368e07bb314f926816d3440a95bac"
    sha256 cellar: :any_skip_relocation, sonoma:        "e02812bbd57b2f508a7aa84eb2c7b099e7bfe14d3269e5d747ed3bfa13630d38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afd45f55f6c36bf0d6b13c161b338f5cb41b46d250eb6853074f1f5558b37c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62ad47cda1c97067b8a00c2367aa401afd741db29babe32b3984b3dac274f254"
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
