class Wego < Formula
  desc "Weather app for the terminal"
  homepage "https://github.com/schachmat/wego"
  url "https://github.com/schachmat/wego/archive/refs/tags/2.3.tar.gz"
  sha256 "6a7501ab537709d1d9fc04f14e5a2c5a8f99309591a8dae75260caf4a74ce567"
  license "ISC"
  head "https://github.com/schachmat/wego.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2c85e758198c227e569544729dfc874fab8662528cd969a9634deeff13b24438"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c018b940e572be3adf5d7813f7bef94a36ffe8733bd8afadb53e115de28b7a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a72b006e5227806f20935e88d2f8eb85617f32fe1c56904acb986305157885c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a72b006e5227806f20935e88d2f8eb85617f32fe1c56904acb986305157885c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a72b006e5227806f20935e88d2f8eb85617f32fe1c56904acb986305157885c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6d7829893896b8576788a0d7df2f95c59c4ca98df57af9a66f87547a14d01a3"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d7829893896b8576788a0d7df2f95c59c4ca98df57af9a66f87547a14d01a3"
    sha256 cellar: :any_skip_relocation, monterey:       "b6d7829893896b8576788a0d7df2f95c59c4ca98df57af9a66f87547a14d01a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "de837fb971e18f6b3763b0be2178b476699c76697e83b83156d857208650bf97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5028e25c825625552b1788d3ce16572f52eeff6837c983279b1f5c10b44ff74e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["WEGORC"] = testpath/".wegorc"
    assert_match(/No .*API key specified./, shell_output("#{bin}/wego 2>&1", 1))
  end
end
