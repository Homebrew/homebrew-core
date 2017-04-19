class Ratatool < Formula
  desc "Tool for random data sampling and generation"
  homepage "https://github.com/spotify/ratatool"
  url "https://github.com/spotify/ratatool/releases/download/v0.1.4/ratatool-0.1.4.jar"
  sha256 "90e9da5ac9f2d7ff96141fc5ca295b5882896501ac6d656d9211992d5541314c"

  bottle :unneeded

  def install
    libexec.install "ratatool-#{version}.jar"
    bin.write_jar_script libexec/"ratatool-#{version}.jar", "ratatool"
  end

  test do
    shell_output("#{bin}/ratatool")
  end
end
