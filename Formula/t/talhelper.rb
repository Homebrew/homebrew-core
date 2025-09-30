class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.36.tar.gz"
  sha256 "60f18116db6966669215a336e9fbdb896a1536b9484d0758ba575905abbab003"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d15eccb11d131de875496ca18bdcd11e3f665f1253a9de9a457084a8c46b1c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d15eccb11d131de875496ca18bdcd11e3f665f1253a9de9a457084a8c46b1c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d15eccb11d131de875496ca18bdcd11e3f665f1253a9de9a457084a8c46b1c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f77f5543f343de908a2254eee3d832ff45dbded60501197fcb3d4ff03b1064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56ce30ed0707893f7d9bdb1d27ca478ca9783f13c98277d8ccef4df262b81c5"
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
