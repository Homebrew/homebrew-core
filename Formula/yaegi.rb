class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.14.3.tar.gz"
  sha256 "8519560f142657e09d08e9ff292f9aecdf9dde93fecb810f54172dc775747730"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3d72a9990e69ef2fbd63bbf92408fa414ba10291a424edefe5dbf7838bd4a19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eabfb433e8f718961bc83d99868f2a59f45f35b9ff2d6ceae6b152a230f509b"
    sha256 cellar: :any_skip_relocation, monterey:       "174954acb5d92c71144de236f1df9214845a57189da81dee07552f5ea3263ed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6ee4b4fc144728559c72644d806fc5dde64e781d4d1934100a28a33d7971add"
    sha256 cellar: :any_skip_relocation, catalina:       "0a01399d0e1bb3fa7bb979fcd17fcfee0453cdd019ce504a5950640c69c44b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4890f5fbcbbdc97acdccd4c29d89fba9712d5b7dea43fe0829a0b96956a29532"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
