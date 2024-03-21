class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "4884df906a5c2b9b3bc09482c83f2eb61dbc2a3effc91a55e1eae1b7def7a806"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b398f4231ad68efb69f9ba0708bdbb0b64b0e142a6f107b82fda2de7288c2292"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f2be4e1708709d8b066bfd3a29e2cc39160fbd287e72f2dfac771e2e955a3c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6544aae203ae8d0b0bc75bc9cfeb9e6a361017c8434a21666a3a5d8b9676724"
    sha256 cellar: :any_skip_relocation, sonoma:         "053cd51cdeb485447f47a95324a5491c195bed5d963b162ebd8c01427dcd439c"
    sha256 cellar: :any_skip_relocation, ventura:        "9ba2b99222a5351c768ca34719c900f402ea01b48bab7fb75072a32d2b821193"
    sha256 cellar: :any_skip_relocation, monterey:       "5ccff840fed5898a5caa44fa62b491c6a1b08102d002715eef63c07a7d2b075e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0483ef55bf59fa36e39010c8a306dcc363b6ec151f8a4c9ad4eb8a233e4500"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
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
