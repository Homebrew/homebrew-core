class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.7.tar.gz"
  sha256 "a9eb86d7206b36a42135f45badf393201af4b56e930ff07863595f93124a4a78"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3559b590a6988b57ed9ec8b2dd8c9683ac9951e41f4b2c1775bb52ec9ad7b250" => :big_sur
    sha256 "19593b6f2c76751622909798e95b5bb1758afbae200c54f774831806cf93b39c" => :catalina
    sha256 "eefbce92ba2c013928e1afd5679685156321308d7f417b61dee6c25da2125490" => :mojave
    sha256 "f04b5d681038ef05499ad02f197e3c4c13f40c3eab51788dc16cedd8f3008f21" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
