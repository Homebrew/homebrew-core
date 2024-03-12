class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "a5011187487f7ed42491ee54ffbba60a31b3f45af7d7f4239411d22f8563e7ed"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e03df17ee7a5656606dc9ea545b67da9589491acb9cd9e935f59fc607a52530"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9205569bc874a8d241b9c2dacca162950943cbd7bbe1ea01bd1f42667c089e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "016dea1297836d5bf1ac44b8a6c9292fdc778c9d649169954b38566260850d98"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e9d09e89c33bd9b725e12f47d647e4edfdf3dc574820f7f19c2f23cb1b0f459"
    sha256 cellar: :any_skip_relocation, ventura:        "3d49b829b9562247f498161179fd604ee0f00366fbf1c340e4b3ba4e10217bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "69eb292363064852250e73ce122c0f9502469fb5406c61f93d2e4ffd30398f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8ef28591b2c86fb261b99098a9113d79b49ee40768c1ca4f5597c2f4bf11d4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"vultr", "version"
  end
end
