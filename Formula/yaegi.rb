class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.9.tar.gz"
  sha256 "362509769fda245b4ac24264d6a8569699807eddc75f97aaeca27b191159e183"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "144f6a79dd8538807c32f360eeea485bed53ce4e9d4fce68119188d6ae8eace3" => :big_sur
    sha256 "9f60719fb3cad54593ecc6c51509aabae24f8dd15da59b85d03891937530b378" => :arm64_big_sur
    sha256 "6597eb7396575eb91e3e68dc0cfcb1525b1f92c48256a55888d953e190fe3ea7" => :catalina
    sha256 "8adbcfb6777e54f80c465c709e7ff9e93bb8ef87c65cb43589ddec3084898624" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
