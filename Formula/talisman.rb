class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.8.0.tar.gz"
  sha256 "12dbf3b314ae0ca0f0b66ce2da229e7e5d1a7ae1ae2f233630ed4381cc3aa074"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec23d0e2d2f20387791be6e20527aca0687aa5d661f3b5009ef475fadd88bc63" => :catalina
    sha256 "c567375230ff8a7570ae244a005f71d2835046adfb80449252da2c0c33362a24" => :mojave
    sha256 "ace414ad0081185c88dd14aa96cfeac48531d8f7e14565cd4b9abd59f8fbda59" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
