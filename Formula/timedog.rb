class Timedog < Formula
  desc "Lists files that were saved by a backup of the macOS Time Machine"
  homepage "https://github.com/nlfiedler/timedog"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/timedog/timedog-1.3.zip"
  sha256 "4683f37a28407dabc5c56dc45e6480dd2db460289321edce8980a236cc2787ec"
  head "https://github.com/nlfiedler/timedog.git"

  bottle :unneeded

  def install
    bin.install "timedog"
  end

  test do
    assert_match "Cannot locate timemachine directory", shell_output("#{bin}/timedog 2>&1", 2)
  end
end
