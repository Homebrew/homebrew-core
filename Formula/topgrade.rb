class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.8.0.tar.gz"
  sha256 "6f72962d0ccc90530f031612e9683a42d05995da6496b591e3f374505551c37a"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d40f4c24a32a61223c26bf6d707297ed4a128967715cd69522aa5afe7ef1fd1" => :mojave
    sha256 "60d9e37c68b81dd883fd8977c54fdad4e5acc12273f304a67f7ac94198b6ee02" => :high_sierra
    sha256 "ad3a219deebb8f92014e7f7f73650da68526a37658c20fef5098fae154525a11" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
