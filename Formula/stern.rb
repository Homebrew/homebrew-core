class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.13.1.tar.gz"
  sha256 "36eff0cd19bb5d60d2f6dfcecfe8afd2e95f00fff2e0e99f38eb99df11de1e61"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2ef4eb2ba0ef91c0b687801b2d36eeecad1c4bfdba0d547c30bad07cb24ec4a" => :big_sur
    sha256 "161fa35aea584ef3065d55441602e6a453bc2b55deb52691b5bd23eb4a9bdbfa" => :catalina
    sha256 "4a520ca8ac031e5bfe72ebab6d535f5d0d15918ff0e23348df66694050f92c6e" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/stern/stern/cmd.version=#{version}", *std_go_args

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
