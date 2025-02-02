class Tgpt < Formula
  desc "Command-line tool to interact with ChatGPT"
  homepage "https://github.com/aandrew-me/tgpt"
  version "2.9.0"
  license "GPL-3.0-only"

  on_arm do
    on_macos do
      url "https://github.com/aandrew-me/tgpt/releases/download/v#{version}/tgpt-mac-arm64"
      sha256 "cda340d4a378a0b6bb434d4a2feaea44d7f0edf6004930c3ea7765ce7392e952"
      def install
        bin.install "tgpt-mac-arm64" => "tgpt"
      end
    end
    on_linux do
      url "https://github.com/aandrew-me/tgpt/releases/download/v#{version}/tgpt-linux-arm64"
      sha256 "c54d7c66ff0d82c3261cdc5926f3171965b0523bbcbb24ae8f120ad2aaaafbbe"
      def install
        bin.install "tgpt-linux-arm64" => "tgpt"
      end
    end
  end
  on_intel do
    on_macos do
      url "https://github.com/aandrew-me/tgpt/releases/download/v#{version}/tgpt-mac-amd64"
      sha256 "3f25ac5f5a8abc5a2b9c24e595e4003e9369c0e94b05e291e9a70e119d530051"
      def install
        bin.install "tgpt-mac-amd64" => "tgpt"
      end
    end
    on_linux do
      url "https://github.com/aandrew-me/tgpt/releases/download/v#{version}/tgpt-linux-amd64"
      sha256 "2b35fbb0025b4398185640f5e93d5e92fe1716315307a70a51e8c9f20124967a"
      def install
        bin.install "tgpt-linux-amd64" => "tgpt"
      end
    end
  end

  test do
    # Simple version check to confirm binary is functional
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")
  end
end
