class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://github.com/iyear/tdl"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "09229d333db613ce55155125b04f1e3269113586dca10b5e24d47450fc73f4ae"
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