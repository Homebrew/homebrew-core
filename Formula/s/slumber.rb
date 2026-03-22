class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "4d8972af3af169538804d0da647520d3c8485daec1f882e15e6cad3e48307b68"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d05d788a8d682f471aea7fc0442018144990300b589a38bf08a03517ab1944ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d1e988fbe55ff65a1e6d5a10a2b2663ffddcea9988824dc03ca2ff8b3c201e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e2c431209af698922ed751a368b6523353e19892746078263493c502440b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f27ff2d4c7441e37a9f6b176a423f494223f81d62e04f4f973634498be0fee16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84e2a18e38d80915d893e2d25ae18adfc5fd99f62354c7dc2cacea77b3bbace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03ea3a03f515eed4719ddbbd7495d3520d2af4b75d0dc3862bff4fb476650782"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
