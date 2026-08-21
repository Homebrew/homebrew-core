class Rmpc < Formula
  desc "Terminal based Media Player Client with album art support"
  homepage "https://mierak.github.io/rmpc/"
  url "https://github.com/mierak/rmpc/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "930019066228d18e9530a8c0d77f10e231ab5efbbbca73b331efcd6fbb47557d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eae3f3a66d109441455c7d5a9ba1715b9acc66e3f9895a5cf78a68a723ff46eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c43267335e51ed5661c97ac724fe0e596d4fa9b0b78eca3f9545e2dbd658b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3416e2dc5f8227d8cd758c78b92d7c6eb24e4a9e0f3cff2de1375912447f1f88"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb5dc539954b54a5893ef01575b147e9b6a214dd94930d96a83b2c92b834996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2246972890356c390f9c500cbb6686528a8072bbb84a2b3a3ae242e7f8cbe269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb467d5b4fd4950b62fc7023e5e4d852755325e6d9d79c6fabedc171e0f4030"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/#!\[enable/, shell_output("#{bin}/rmpc config"))
  end
end
