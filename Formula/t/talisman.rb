class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "765d585fff532882d65d63dca2455edead2a392452a42e7089a600c23b46e5c8"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "439c663606b18117d4cdd1884160ef603fb0d7c68e553eb063fca14b39238999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "439c663606b18117d4cdd1884160ef603fb0d7c68e553eb063fca14b39238999"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "439c663606b18117d4cdd1884160ef603fb0d7c68e553eb063fca14b39238999"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7eab5efa9a3fba31a1792cac29cbfdebc158d8a47279d146593c072ecc191b"
    sha256 cellar: :any_skip_relocation, ventura:       "df7eab5efa9a3fba31a1792cac29cbfdebc158d8a47279d146593c072ecc191b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78e8ccd470d0cf25876ac971baecaec7b27cbba1826b8e99b09598ad0859631"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
