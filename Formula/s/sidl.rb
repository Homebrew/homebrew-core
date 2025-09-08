class Sidl < Formula
  desc "CLI tool to retrieve information about Twilio SIDs"
  homepage "https://github.com/kwame-Owusu/sidl"
  url "https://github.com/kwame-Owusu/sidl/releases/download/v1.0.0/sidl-darwin-amd64"
  sha256 "ad8438989f510cf6aebbb2bc10ca6bc222ec36060f2d0db608dd03c0b0dd5f94"
  version "1.0.0"

  def install
    bin.install "sidl-darwin-amd64" => "sidl"
  end
end
