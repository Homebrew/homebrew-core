class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://github.com/wait4x/wait4x/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "5b8e4ceaefd3902cda157aebd01dae76e29d7c93893fba7eacf7eb1a0ef17c27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "873a4dbc6c0a3cba863b54345638cd99e42b94d4bf8f5f30f703872dfee6998a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904540878870a12881db9cd848237254e9088cef14488e8ff5dfae174387085a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3532dfa326de95c1a6d622be47a3cf4ec83eac56a00894fb711b614b220d1f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2fb789e633fc517647f200b1b70a76947f44cd33ae7b3a204277442a0994122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07256649fd60fdac7e2aedceddb3805f7aeb5ef030014beaf9fa4ffbf0a36a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ac8efca6a7f91489119531764c7adb18f3b5e31770088fc79da375202b6986"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "dist/wait4x"
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end
