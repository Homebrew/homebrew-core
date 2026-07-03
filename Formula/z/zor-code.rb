class ZorCode < Formula
  desc "Open-source AI coding agent for the terminal"
  homepage "https://github.com/Zor-AI/zor"
  license "MIT"
  version "0.1.0"

  on_macos do
    url "https://github.com/Zor-AI/zor/releases/download/v#{version}/zor-code-darwin-arm64"
    sha256 "f4b502cccae018a04938ee6d85d71184c2979124efe99fb0109cc20af38a52fe"
  end

  on_linux do
    url "https://github.com/Zor-AI/zor/releases/download/v#{version}/zor-code-linux-x86_64"
    sha256 "306a3cd722eba31b00f67bb387e11dc19f54bb685e109360b6fae71b95f5e27b"
  end

  def install
    if OS.mac?
      bin.install "zor-code-darwin-arm64" => "zor-code"
    elsif OS.linux?
      bin.install "zor-code-linux-x86_64" => "zor-code"
    end
  end

  test do
    assert_match "Zor Code", shell_output("#{bin}/zor-code --version 2>&1")
  end
end
