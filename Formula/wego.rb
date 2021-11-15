require "language/go"

class Wego < Formula
  desc "Weather app for the terminal"
  homepage "https://github.com/schachmat/wego"
  url "https://github.com/schachmat/wego/archive/2.0.tar.gz"
  sha256 "d63d79520b385c4ed921c7decc37a0b85c40af66600f8a5733514e04d3048075"
  license "ISC"
  head "https://github.com/schachmat/wego.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1facb6e34de84897466683821fb2b3b0198bfb063a4eaa75658e0d7e2ea099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dd22ca29b4b1c7ffd10d9780a4db4dfb9db52dcef73ba07fe85f23a14aa472b"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b25857aaa0a48c2990b53e7efded2a2b6feaab8d92f476b931e3cc530cb3d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff772c99d0aebc8e471aa4785b7a429fda2c0af8ede5d43fb2ee1ba8c7617246"
    sha256 cellar: :any_skip_relocation, catalina:       "5ac6a153a25c0d68564d000f52642d0891fc85de2183732b9d7b171b5e629146"
    sha256 cellar: :any_skip_relocation, mojave:         "436dbf3a2dd0f517635078c987d95985941be4aaae3efc65b5fb2e3562af87cd"
    sha256 cellar: :any_skip_relocation, high_sierra:    "dc3714d72fde13770cec00100aa1ee843b944512c454e00ad131c822e868cedb"
    sha256 cellar: :any_skip_relocation, sierra:         "504d831a34c22ec006a610f7af4d11000708570513e5391e2077d021ca6b3758"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ccdba75878ffe9b62b49265f6f4b375da80f44e6c5b7c5a40294501fda8903b1"
    sha256 cellar: :any_skip_relocation, yosemite:       "97e7c2edfa9b1a312a0f4f4bce9553b1c8e884409aca3f7acfed2dc99fcef05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48f143251c87b71fcfaedb410aace7b51d56127c882bc023a7c8f28458d8ef89"
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        revision: "ed8eb9e318d7a84ce5915b495b7d35e0cfe7b5a8"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        revision: "d6bea18f789704b5f83375793155289da36a3c7f"
  end

  go_resource "github.com/schachmat/ingo" do
    url "https://github.com/schachmat/ingo.git",
        revision: "b1887f863beaeb31b3924e839dfed3cf3a981ea8"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/schachmat").mkpath
    ln_sf buildpath, buildpath/"src/github.com/schachmat/wego"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"wego"
  end

  test do
    ENV["WEGORC"] = testpath/".wegorc"
    assert_match(/No .*API key specified./, shell_output("#{bin}/wego 2>&1", 1))
  end
end
