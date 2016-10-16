class Timedog < Formula
  desc "Lists files that were saved by a backup of the macOS Time Machine"
  homepage "https://github.com/nlfiedler/timedog"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/timedog/timedog-1.3.zip"
  sha256 "4683f37a28407dabc5c56dc45e6480dd2db460289321edce8980a236cc2787ec"

  bottle :unneeded

  def install
    bin.install "timedog"
  end
end
