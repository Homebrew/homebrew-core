class WechatPlugin < Formula
  desc "Powerful assistant for wechat macOS"
  homepage "https://github.com/TKkk-iOSer/WeChatPlugin-MacOS"
  url "https://github.com/TKkk-iOSer/WeChatPlugin-MacOS/archive/v1.7.2.tar.gz"
  sha256 "80a079c71c6aba93197603310258bf25567a0df3ae969404f9a2de58372363de"

  def install
    pkgshare.install ["Other"]
  end

  def caveats; <<~EOS
    To install the plugin:
    sudo #{HOMEBREW_PREFIX}/share/wechat-plugin/Other/install.sh

    To uninstall the plugin:
    sudo #{HOMEBREW_PREFIX}/share/wechat-plugin/Other/uninstall.sh

  EOS
  end

  test do
    system "test", "-d", "/Applications/WeChat.app/Contents/MacOS/WeChatPlugin.framework"
  end
end
