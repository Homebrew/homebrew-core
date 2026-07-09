class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "3a6721c3409c70449c24a5b33f83d0d05026f2318fe052db5c6d0834e2b29c6c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e028240c7ac48f9a5ab7268cc05bfae54ec567ed3465059e93fa4e34cde8e2eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb3e88e6b7cf033d76c8b7a71cf9345cbbc4429e29d52b072245d033bd4dcc45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b89022667a934d02d215fad579e1be8275df7cdf9024ca26dfc2990b61e3483"
    sha256 cellar: :any_skip_relocation, sonoma:        "35d8e433a98297b98e00fd10513c9d02bd4f66415ddc86cea7cb2403d926c5f3"
    sha256 cellar: :any,                 arm64_linux:   "3fdb379f0882fb7546d142b34a4bc929eaafd9de79dec00e4852b5efbcffae99"
    sha256 cellar: :any,                 x86_64_linux:  "a750c0742d30f56b8f8c5826b865c86e9f3df35148a97b3cbdcfd022e50e79be"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"script.sh").write <<~SH
      dog="poodle"
      echo $dog
    SH
    system bin/"shellharden", "--replace", "script.sh"
    assert_match "echo \"$dog\"", (testpath/"script.sh").read
  end
end
