class Viro < Formula
  desc "Command-line utility for securely managing environment variables"
  homepage "https://meshstudio.io/"
  url "https://s3.amazonaws.com/mesh-homebrew/viro"
  version "1.0.0"
  sha256 "eb22f144fe249e45332edca2a05bb40eccc81a4013b0b555915af74c1345e601"

  def install
    bin.install "viro"
  end

  test do
    system bin/"viro", "--version"
    system "false"
  end
end
