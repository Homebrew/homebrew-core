class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.7.0.tar.gz"
  sha256 "0cd9d02cd52c21ec9d662654f4fd37ce7f795835194d3910e1d2026ced6a7705"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "03cc7fcf822c24887f9e544e93abfa25479a3b97660cdade24e055a5ed2db845" => :catalina
    sha256 "b49176201212acb51b5f648e74e894063f08c3f0d2784fbb2dbadeabf1ba01df" => :mojave
    sha256 "7eafc50a04d2ffe2ef1de86c10072bb547c81b88eda0258d6ea870f01b799b64" => :high_sierra
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
