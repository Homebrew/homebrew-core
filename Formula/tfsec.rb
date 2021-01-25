class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.37.0.tar.gz"
  sha256 "a48545d42622de597cfbdd22f7460b2731d1c3c0420a6ea0d22948adda5a01ad"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3702da66a5c0dea6452716bfd6dac4f00f2f209712235bb518653db82b43f864" => :big_sur
    sha256 "079d62e3e319c41d1f2bca3251c6ec6dfbc53fb18c5a300a495d42c85f2b5841" => :arm64_big_sur
    sha256 "c805ff1a0fd28e125b8a50d856ed5bda1f2ea79acef062f0a41106129ec460ec" => :catalina
    sha256 "1010c3c74d8621c3bac309d60f414626487bc9310c5f76bae6a5a72b266f5298" => :mojave
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/2d9b76a/example/brew-validate.tf"
    sha256 "3ef5c46e81e9f0b42578fd8ddce959145cd043f87fd621a12140e99681f1128a"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
