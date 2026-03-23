class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.22.4.tar.gz"
  sha256 "bc9747620ae00aca33a1899b4ddb200f42d277ac6d5f58901aba616129f8a3ba"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "443b653666457341c84dd9e7b7a5fc870b58d72fa224bc2359a6390e5a8115c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31be8ef8678004aad2779f79684ce7368623d6714f89b8ea1ca6ef71f90eb4d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec213049940280b1fc85d93ff05153a03c3ae2a255cf38b6aac5c986b97a8e3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4fa60122449a479729222b6aa498749dc29f2c954a20e0b17dcc2e3aa2aa151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f398012dbe5e2c50b8500b78884b1c1663eb8358bdd91e5b3e2c087daacc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8b9c97ad1c1f9b3ee0f1d3f9e07eee123098028f4836339cf84eecb30476c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
