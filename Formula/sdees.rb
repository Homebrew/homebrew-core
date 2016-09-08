class Sdees < Formula
  desc "Serverless Decentralized Editing of Encrypted Stuff"
  homepage "https://github.com/schollz/sdees"
  url "https://github.com/schollz/sdees/releases/download/1.2.1/sdees_osx_amd64.zip"
  version "1.2.1"
  sha256 "8ba3a210518837a0af50d5290a982ae38e2b38b5858112800fdabbca885d6020"

  def install
    bin.install "sdees"
  end

  test do
    system "sdees"
  end
end
