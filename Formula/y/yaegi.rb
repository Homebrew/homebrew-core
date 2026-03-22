class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "872ceac063a8abfa71ecdeb56b1b960ca02abd5e9b6c926ae1bd3eb097cad44b"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1b6aa50f88c249b67a801d000919fae39cc280bc0bdf873ca9da5b0d6bd8df9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "596a9506904a37aeb5a6118af68fbf7a4f316ae8baf70ac3e0d22a14b9bf9831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "596a9506904a37aeb5a6118af68fbf7a4f316ae8baf70ac3e0d22a14b9bf9831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "596a9506904a37aeb5a6118af68fbf7a4f316ae8baf70ac3e0d22a14b9bf9831"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd0481cb3feb07c198f773d117a5153a60b91c126f88d99fcf178dbf5f0bd542"
    sha256 cellar: :any_skip_relocation, ventura:       "bd0481cb3feb07c198f773d117a5153a60b91c126f88d99fcf178dbf5f0bd542"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d9c2fc672532d05981a633e0cfed9cffb5978c6ccec6df79275302bde86ba4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a431dd9b644a57c9fdf96231d53ddbd7f1f8ac9047d87c633e1677b4d9cbf89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output(bin/"yaegi", "println(3 + 1)", 0)
  end
end
