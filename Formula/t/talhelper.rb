class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.41.tar.gz"
  sha256 "33a8f6ac0404d6e38d7aa5d010ac4b6fe0172b54175af70108486fbad2f95072"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc1e690535ed94eaee7053e2aceb8c614f13d8d8a29c2a485925c687e7d41c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc1e690535ed94eaee7053e2aceb8c614f13d8d8a29c2a485925c687e7d41c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc1e690535ed94eaee7053e2aceb8c614f13d8d8a29c2a485925c687e7d41c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9d418f840494ab78f7785689167d81daebfa56bfb7df419f713742e57e98a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "369fff9c234e8f962745500f415f807b01410b6f61110879db949459e4fdab42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2471801697d8555639d2f0537ac58a19384cf6170c1939fcb8d22d6c3698332"
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
