class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.17.tar.gz"
  sha256 "204a1431f215802cc32bd89cc26eddf4eb8c9b0809da386c5f99cc69eec143e0"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e848575ce94261ab0e1943a3d8ccca5f871d91426397c968a530a3e8177cfacd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cd573e2db0bd3d504b3e0d256662231b1ace5807ed21ea1597996b8faefbf23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cd573e2db0bd3d504b3e0d256662231b1ace5807ed21ea1597996b8faefbf23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5cd573e2db0bd3d504b3e0d256662231b1ace5807ed21ea1597996b8faefbf23"
    sha256 cellar: :any_skip_relocation, sonoma:            "04787acbd0dc9d2371aa1daba5b40981cee26b82166b1680147aabf7ede8e2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d5f353a012193f518dc61a97735eb0ba01436d552f48161feda5d744709efb24"
    sha256 cellar: :any,                 x86_64_linux:      "2801780d08a6eb2488a8623b1f20e0d65e4855a9aa4f9e1b90931c20f068eeea"
  end

  deprecate! date: "2026-08-26", because: :repo_archived
  disable! date: "2027-08-26", because: :repo_archived

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
