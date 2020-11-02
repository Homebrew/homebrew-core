class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.10.0.tar.gz"
  sha256 "b9640e84044e827f1d9f1c458977150b04bc6ccd96d78e8f5148e0ba7ddafb6b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cb03fd1a302b68182f904e86956c04c3ff2f9ce1c91772b57131d3e0b6c127a" => :catalina
    sha256 "3c9dea291eaf9ff4c356691af8990de6b13686dcc2d63c964cbddb48ddae14d3" => :mojave
    sha256 "e32bd2a2a0dc08323da12000e1a29fa2cd8ec29c69ac8b6a992549b768354c76" => :high_sierra
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
