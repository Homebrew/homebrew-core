class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.15.0.tar.gz"
  sha256 "87a23db05a5ac4810b8f6143d6e8b134a4831cd085b4072eba2ead014bd0b221"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "49ca3b4fdc3db404de19808afe32a808b5f0811143da2b94f91d54cfbd2da019" => :mojave
    sha256 "7a8f32b3548dfdf836679a227badb22d378445ff8aea7a8b4d60f56819938f05" => :high_sierra
    sha256 "c9227751f66441eaee7b1334c73d98b3cf0aea5ec1721a42e7f7ee157d9d688d" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
