class Wai < Formula
  desc "The official contribution CLI for w.ai"
  homepage "https://w.ai/"
  url "https://releases.w.ai/production/cli/brew/wai-0.1.3.tar.gz"
  sha256 "bf3741f7ea6c01a79491945ba6544b77d878fab2f8356506808f52c24c76fbff"
  version "0.1.3"

  def install
    bin.install "wai"
    bin.install "w.ai"
    bin.install "w-ai"
  end
end
