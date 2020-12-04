class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.13.1.tar.gz"
  sha256 "36eff0cd19bb5d60d2f6dfcecfe8afd2e95f00fff2e0e99f38eb99df11de1e61"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f8f6af5554f315bd5865e29df96c78227adf7dc3b760ce4405a78aef46842a5" => :big_sur
    sha256 "d6dbc6b4d2bc279d0fe11f755ff22076275dc63f860507fea7c25b290cf4923a" => :catalina
    sha256 "888437271eb402c05e692d69bc469d6a471c475a4f8a1c2434c097470b79ace1" => :mojave
    sha256 "36b25df7f6bdd4efdd90bb379e00e423da5e1123151c040b707cbf3f0f049d09" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/stern/stern/cmd.version=#{version}", *std_go_args
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
