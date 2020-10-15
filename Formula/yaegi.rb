class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.3.tar.gz"
  sha256 "f82a9bffcd2384ecf6e80e36b9f49364ef4b4b987ebd597d509eb15b43a9888b"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b6f3936f2b561aa024ffaa6c641f54283fb91851c6e5e099fd7ea8c3b590d7f" => :catalina
    sha256 "33d4c1e0329bcdd1e9f871e8defdb36fb6805f4daf9e3835a159730133c9b23d" => :mojave
    sha256 "9071fe607fb9edcba1d3c2b353cf7d87ad250ffa636772e3969a9feeadfbe964" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
