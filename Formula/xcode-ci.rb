class XcodeCi < Formula
  desc "CI iOS/MacOS app via command-line"
  homepage "https://tungse1209.github.io/xcode-ci/"
  url "https://github.com/tungse1209/xcode-ci/archive/v1.1.5.tar.gz"
  sha256 "9c6cca4220c51c00d8c4545daf85385d8d2daee93bfbc3c78497ee1ddb51ab35"

  def install
    bin.install "xcode-ci"
    prefix.install "Author"
    prefix.install "README.md"
    prefix.install "hooks"
    prefix.install "config"
    prefix.install "helper"
  end

  test do
    assert_match "ok", ` #{bin}/xcode-ci __test_cmd `
  end
end
