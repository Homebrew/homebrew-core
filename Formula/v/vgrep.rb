class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "0fb2ca6df8cdbb57bc50589e626e456f8a62b2d8d545b93425070844fcff26ea"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  # The leading `v` in this regex is intentionally non-optional, as we need to
  # exclude a few older tags that use a different version scheme and would
  # erroneously appear as newer than the newest version. We can't check the
  # "latest" release on GitHub because it's sometimes a lower version that was
  # released after a higher version (i.e., "latest" is the most recent release
  # but not necessarily the newest version in this context).
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eee88f7fa0d849ceed26a317346d495dc4e4014ff032f911724f6584af1f7772"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0259fe9dd8c68ea38179680e1f6f6aeeb2dff5af23043285c884ac32e8e560ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67cbb9df6b7f97b0fbdf50bbb57949d9cf2a0c0decaa45db7501ea283ed16010"
    sha256 cellar: :any_skip_relocation, sonoma:         "44e395cf96b463e771dfb45d599f375864adaa92c8089684eda8c46c68eb770c"
    sha256 cellar: :any_skip_relocation, ventura:        "cb7c636816ca7a7f9dfe70843a8cb86f9a5846bc99f679df997e7f67980501b7"
    sha256 cellar: :any_skip_relocation, monterey:       "e6baee28a056076a44e1e37272da0187a70f29f1affbf34a0cc7b9ab8055d22a"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less .")
    assert_match "Hello from", output
    assert_match "Homebrew", output
  end
end
