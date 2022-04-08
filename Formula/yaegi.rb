class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.11.3.tar.gz"
  sha256 "46e73955145cd829e41a906677edfcd78846862ca0274770dd4668dda2a949c1"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae0fd5ae35e03c666fedb31b50e60099a3099f215daebd5fe425587eabc1f60a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "358064ab32eea1f7672cb3df1ead7d873ff88ba0b09343115f1c93d8fb0ee61d"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9d490551d6fea8604a97c1e8be7bab87cae3b95fada99a01fa64d677733934"
    sha256 cellar: :any_skip_relocation, big_sur:        "a18de82be6eed89b4fa856444ed1a24fa7750f7f28e33c7707b8827a0e5ba31a"
    sha256 cellar: :any_skip_relocation, catalina:       "378570b7613ed6460b17bb7cb1681dfe49d099155b00466c331caa6e5d8d0584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de51e61a6ff89c377cf2ffcba5a01fa31c71a85e20f944018e38a5106aeea248"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
