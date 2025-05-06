class Rmds < Formula
  desc "Remove all .DS_Store files recursively from current directory"
  homepage "https://github.com/fitchmultz/rmds"
  url "https://github.com/fitchmultz/rmds/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e59532a7a1cfecd37fdd1f9698606b111d43eb7ad1aac36bc5a34b154f8f6cdc"
  license "MIT"

  def install
    bin.install "rmds"
    man1.install "rmds.1"
  end

  test do
    # Create a test .DS_Store file
    touch "#{testpath}/.DS_Store"
    system bin/"rmds"
    refute_path_exists "#{testpath}/.DS_Store"

    # Test help flag
    assert_match "Usage: rmds", shell_output(bin/"rmds --help")
  end
end
