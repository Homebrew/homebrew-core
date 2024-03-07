class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "e839bde2fd94e2c71d6c4492f09257f864369cfa355f458556c7be06af165327"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8122622d012a1646629cef77457197775af1e4c201f270770be466a8888f09b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a5f746602face7db70b7712de06ca6b5cfddb08fdcf8380aba506c70cc005d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fffed7ea761a407621417957a087cf33ab7bcc5e4a652cf1e8015e7d6427f03a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc6910506425a90c7b202b9d7f139370760738f3f410cf97e84ecd37260468b"
    sha256 cellar: :any_skip_relocation, ventura:        "bcb9eac92987b251f86f0f189dc926fbc5cc1825a8261cc130412f35a13c1f68"
    sha256 cellar: :any_skip_relocation, monterey:       "ded9d3455a9965d953c5b06745727c6cfc126d0e2ed35316e94ed21e4a550d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3361207b60c44d7286d14b4fa003728fe524d96c8bd913f2e92acfe355ec8ad6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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
