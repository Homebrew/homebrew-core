class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/releases/download/v0.6.2/signal-cli-0.6.2.tar.gz"
  sha256 "d917507211b3419e271674df7f03c8189921e2e78a389479a612847ddc8f1614"
  depends_on :java => "1.7+"

  def install
    # pattern taken from activemq
    libexec.install Dir["lib", "bin"]
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.java_home_env("1.6+")
  end

  test do
    begin
      io = IO.popen("#{bin}/signal-cli link", :err => [:child, :out])
      sleep 6
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "tsdevice:/?uuid=", io.read
  end
end
