class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.11.3.tar.gz"
  sha256 "46e73955145cd829e41a906677edfcd78846862ca0274770dd4668dda2a949c1"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35af9f3f3cac5ec10b6c757e103a52a27feb570a68664a1e4880b01837d406bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb59cfe0916259b042edb66b9df478ac53f61117b74d7cf616b32c9d2c04593e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ed5cf0e20f9b8c348b2c8296d96ac8aa5b40e50a87f5c0f42e2a7124a8c8625"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef53b51931f7cbc241b9774cfd0adf9a3578f3f87213127e53f7af2db43d68e"
    sha256 cellar: :any_skip_relocation, catalina:       "b59d9ce2db6f2b316b56960d399824044b40192b0a4ac6be7ca40665733c9dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c8fe40521c36a673eb867ac81f1bcd44c85fe5119db1c3555d5ead3d9e1f3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
