class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.28.1.tar.gz"
  sha256 "687fc7861820cb62c847cff53b27845af13cbd445bc6ddfbdc612037e8fcde0d"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa94dcd0e6497388dcc92ec8b1c79a8b4f0e2bbdb71c97debbf4e2535d7b76e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2627bd5684302439a326cd320146131c1d35188e9e4a5ac2d7eca1e4d9ab6ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "2350477b98ff5d6fbfcb8fa73733877472a23ee2bf514ab4b56aff19ecf17469"
    sha256 cellar: :any_skip_relocation, big_sur:        "538836f37a306e352e393d69f9eead72a1ab20d9dbb4037db9b1055ef43e8238"
    sha256 cellar: :any_skip_relocation, catalina:       "0e19ebfd7ae1391e4dfbb989b2020f53424da6a2d59d0e5bba4b4f32705133a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8975c284a2079a30db81abfa19ed8e3dac19c7176532d546bb8fb33a4fcee853"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
