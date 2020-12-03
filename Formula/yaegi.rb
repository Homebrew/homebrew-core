class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.8.tar.gz"
  sha256 "2085aa7f169c58eeaf2082b12b59cac6ff329a87642735613127618e8a1aec62"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "856eff6b596e2d6b0fb8514591ed6cf77559e4e824d924b0066ce03f7e69f5bf" => :big_sur
    sha256 "91d4e12650a681f34b5eb3a4908837a673fb1d87ac4fcf57bcf96ac399504711" => :catalina
    sha256 "7ed28d27be8f7cfdc0a9fca2b2398cd2ddba2e1d35c1da30e4bffac633b8f029" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
