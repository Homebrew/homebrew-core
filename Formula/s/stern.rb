class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "0197c241e847c9068ff10d93aa9059349421a0dfd689df4027490852c2d80ef5"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a5e1ddb24b7e2847f04bf08acf667051d87a48335bb3fcf7c58ba48157f8500"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffd5172c209341af4739477f1cac4355568496a264b6cbb3c9b124d743b5e9f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85276bcb63eb2fedf8340c5e82fedf93b33dcb61901b4db237c761fbcf491c56"
    sha256 cellar: :any_skip_relocation, sonoma:         "401063e0497ae9117269f7797090bd42267895ce13c4193b8af8aa00182245c6"
    sha256 cellar: :any_skip_relocation, ventura:        "f862eb20b8c216306792e77fad4b41681b3573d0077e76331aa2e961a3aafebf"
    sha256 cellar: :any_skip_relocation, monterey:       "16cb3927d14401bbe9d8f82cbf732d4b630906c48b6a10f7a907154c062b65af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640b2c245c0b726f43f45d79031736da9f9aa230d2b6efec0507a7a847c010a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
