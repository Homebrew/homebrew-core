class WhatAnimeTui < Formula
  desc "Another way to find the anime scene using your terminal"
  homepage "https://github.com/mandriota/what-anime-tui"
  on_macos do
    on_arm do
      url "https://github.com/mandriota/what-anime-tui/releases/download/v0.0.4/what-anime-tui_0.0.4_darwin_arm64.tar.gz"
      sha256 "ca964a76b52e02dc0751817c06e8a8ca7d62e926c4ddcd96cc9fa974fc7deb0b"
    end
    on_intel do
      url "https://github.com/mandriota/what-anime-tui/releases/download/v0.0.4/what-anime-tui_0.0.4_darwin_amd64.tar.gz"
      sha256 "04e56c146fe15a62f05b8d0a6d83f2ba8171d423885f544d46ac9b8c7ff145b8"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/mandriota/what-anime-tui/releases/download/v0.0.4/what-anime-tui_0.0.4_linux_arm64.tar.gz"
      sha256 "a11c5cb010c09ea77c0a324a89121a96b3edc20f2d21ed39c6b85fc86f64d48b"
    end
    on_intel do
      url "https://github.com/mandriota/what-anime-tui/releases/download/v0.0.4/what-anime-tui_0.0.4_linux_amd64.tar.gz"
      sha256 "7385a1dece96ddb3c79bbd6815464dbbb3adb17aff8d0e64d14b7a1a24eaecd5"
    end
  end
  license "Apache-2.0"

  def install
    bin.install "what-anime-tui"
  end
end
