class TelegramOwl < Formula
  desc "🦉 A lightweight CLI utility to send messages and media files to Telegram chats and channels — directly from your terminal."
  homepage "https://github.com/beeyev/telegram-owl/"
  url "https://github.com/beeyev/telegram-owl/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "bc1f902498053a673076cad894ce34a7a543c3304661b2b0435e437700ff42d4"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/beeyev/telegram-owl/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegram-owl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegram-owl --version")
  end
end
