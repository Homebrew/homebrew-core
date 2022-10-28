class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.14.3.tar.gz"
  sha256 "8519560f142657e09d08e9ff292f9aecdf9dde93fecb810f54172dc775747730"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70e9c53f8c1fcf3333f171d331c9069e020e1799ef46370923eb6709c18cd13c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a348d0482dd35be117bc9c9f70640d6f447159bed825442084c37cc224d192aa"
    sha256 cellar: :any_skip_relocation, monterey:       "77c7884e2d649f850d6a308c9bb6b4774f566fa735aa618c0b6e3727c317e42a"
    sha256 cellar: :any_skip_relocation, big_sur:        "341432d91658a01fa199a2dc399015f767857f37ce9934ccf3505eb765000eab"
    sha256 cellar: :any_skip_relocation, catalina:       "003001e8a7fc7f0c41d60aec4b2ea19fafe36cfd0abb81d9515322103240625d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a837bd81816c63f046e0b1d1705d65f8c53ca90c011fe004defd9376855b715"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
