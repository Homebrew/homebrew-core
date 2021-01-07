class Up < Formula
  desc "Tool for writing command-line pipes with instant live preview"
  homepage "https://github.com/akavel/up"
  url "https://github.com/akavel/up/archive/v0.4.tar.gz"
  sha256 "3ea2161ce77e68d7e34873cc80324f372a3b3f63bed9f1ad1aefd7969dd0c1d1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b512ce52999ccd4c5660ec09a277e2f575e1da94a7fa5f1d0a67bff3b67da2f" => :big_sur
    sha256 "4acef697aef1068c1bc633973dbd15e3b036e8abaf0c3fa6562cfa86f0c90a55" => :arm64_big_sur
    sha256 "0b7f8e1fdef01b1395acd9331cae1bd15b703d244692ac108e0c9f3d2e75b170" => :catalina
    sha256 "fbe848c08368b189a0a97372a5b11848d72d2c6759a7c877e1628e9e4439ba30" => :mojave
    sha256 "5059e775356194442c930aecf199b7a418c3c6ecdd8b82db078c26970a1b3af5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "up.go"
  end

  test do
    assert_match "error", shell_output("#{bin}/up --debug 2>&1", 1)
    assert_predicate testpath/"up.debug", :exist?, "up.debug not found"
    assert_includes File.read(testpath/"up.debug"), "checking $SHELL"
  end
end
