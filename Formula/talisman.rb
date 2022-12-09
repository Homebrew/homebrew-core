class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.29.4.tar.gz"
  sha256 "e0b3326cbad011914870ddee69b550707cc89c2d49a77f311b138040a59f5728"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f388dfe1f25726b4c44e92309eae1c3e4ee8b78f8498b364d517019a5c678137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a3bafb435e7a26a79de5af253b6497b7190c1d231ca32cd8621cca485149223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7047e4d426177c6f5e159ce1c48c215f45330943d46eed50b5ac170c0621ad77"
    sha256 cellar: :any_skip_relocation, ventura:        "c4d4afcd22bdb143dbbd4e996e5e28550378f23254d84047de8f1e3f2333efd7"
    sha256 cellar: :any_skip_relocation, monterey:       "387345e2e0ba7f0d354edd730630d1afaeb1fb7a6761c5e925311277ba6183df"
    sha256 cellar: :any_skip_relocation, big_sur:        "02d007b341aa5d1651837653097def3a21a52134507b18cbdc7cf21ba473bdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a102bf835ad333e989d90a50f1fb21a381e64874f4dd87aa6372aa03779afeaa"
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
