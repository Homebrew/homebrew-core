class Awless < Formula
  desc "Mighty CLI for AWS"
  homepage "https://github.com/wallix/awless"
  url "https://github.com/wallix/awless/releases/download/0.0.13/awless-darwin-amd64.zip"
  version "0.0.13"
  sha256 "e4038b1ce8c56414b9e139834f71844ecf0b87599aeb032a7b4d2dff3f424131"

  def install
    bin.install "awless"
  end

  test do
    `awless --version`.start_with?("awless version=#{version}")
  end
end
