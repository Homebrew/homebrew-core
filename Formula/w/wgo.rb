class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "2ab2e49db58c25e424c979dddf54e1efdaeb210ce6f224a35e9eec5e52549583"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2b92e968a82f99328678374d06ce7596cfee234d84fd2f0f8f7abe3b7fb6086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2b92e968a82f99328678374d06ce7596cfee234d84fd2f0f8f7abe3b7fb6086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2b92e968a82f99328678374d06ce7596cfee234d84fd2f0f8f7abe3b7fb6086"
    sha256 cellar: :any_skip_relocation, sonoma:        "b650c2c0ec76ad70ac89a5975fc1837a9577f9c02aa0b619c96d0b08c6b51241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1811a14743469a2c1ffa8bd0026d0002a1f9a4fa204b17f3f7d049a98047a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a37ea3c23353f2300673c562fd2a69307bc0a71510c696ac973509138b12889"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
