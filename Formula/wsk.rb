class Wsk < Formula
  desc "OpenWhisk CLI"
  homepage "https://console.ng.bluemix.net/openwhisk/cli"
  url "https://openwhisk.ng.bluemix.net/cli/go/download/mac/amd64/OpenWhisk_CLI-mac.zip"
  version "0.1.0"

  def install
    bin.install "wsk"
  end

  def caveats
    <<-EOS.undent
      Until OpenWhisk project does not provide an official version for the CLI tools,
      to upgrade we must uninstall/install the formula.
    EOS
  end

  test do
    system "true"
  end
end
