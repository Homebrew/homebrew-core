class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://github.com/iyear/tdl"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "0048003955d674583b0b7b05771f81341e2a5a15e2e4e9fb09c11814f984b617"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"tdl", ldflags: "-s -w")
  end

  test do
    assert_match "# ID of dialog", shell_output("#{bin}/tdl chat ls -f -").strip
    assert_match "callback: not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1).strip
  end
end
