class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.16.tar.gz"
  sha256 "ea42f41d2113b2c467fe530348efb093b1288aa15c7d6f657ef04ee9c01420c7"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efdd8fbe713091da92c6423234999a27b64d28317f6e53f5dc44ae3c57e23ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efdd8fbe713091da92c6423234999a27b64d28317f6e53f5dc44ae3c57e23ca4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efdd8fbe713091da92c6423234999a27b64d28317f6e53f5dc44ae3c57e23ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f7d741690c62fa6de22384f544af9998db316f51e943721e8d6f1d63722039f"
    sha256 cellar: :any_skip_relocation, ventura:       "6f7d741690c62fa6de22384f544af9998db316f51e943721e8d6f1d63722039f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a2fdaf1bb775903afd769edd24162c41245b23040aab87c906297aa845a6bc4"
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
