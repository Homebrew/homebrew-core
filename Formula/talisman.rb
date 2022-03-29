class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.27.0.tar.gz"
  sha256 "2eb244553dfbb5f97fcab1774f2d1295cae9e7d4ee8f9d3b351ea5aef1387a78"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ee70262379eb0f96a518f312932b217b0fd0644d96b7698b88bb00bacb0659"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8408b2279ac5f2858118fc55de6396410dee53cc17e7727df4caeca32b56b53f"
    sha256 cellar: :any_skip_relocation, monterey:       "5cda93c419a3eb2e8c5b812d5e0281dcc505e2078e61173c59ad47ffe37a023d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3af630daff7bdab295b0b8146af5c2ea012a15c9ac174dc500595b3c0656f6d6"
    sha256 cellar: :any_skip_relocation, catalina:       "a8cce90009934e11a566008c28a959217b7fbd2511862e0842f68f9b79d130f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9a54edf4357fb9f057f6a794f86002da25923fc5890cbe08cf20148ff7cf4cc"
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
