class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.11.0.tar.gz"
  sha256 "95ebb3ac0215bf43d6cdf17d320e22601a3a7228d979e5a6cbaf8c4082f9ad22"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5a8ea0a5a329508e1097c444fb30b048c21a718924fc74058fd272d2d041101" => :big_sur
    sha256 "a6682d9be9f24e3e7251a5006643bd518d485d1f32d1b2a61d52efeea08317e7" => :catalina
    sha256 "468ada5252b7c8383ef357f3cd2d39d43c8870d55638a4bcdf022c0b6b6715df" => :mojave
    sha256 "ed7afe4da9e5d164521b978dc6c680b8026e54fd6a21c0db27e5474d4e89a72e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
