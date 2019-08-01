class Zenio < Formula
  desc "CLI Zenio Tool"
  homepage "https://dev.zenio.co"
  url "https://zenio.co/cli/download/distributions/v0.8.5/zenio-0.8.5.tar"
  sha256 "0c30ab42cdc2298cc38ce52e492f7e001e8e68ee3ab71ce4f46229a5e8f3b35f"

  depends_on :java => "8"

  def install
    inreplace "zenio", "##PREFIX##", libexec
    inreplace "zenio", "##VERSION##", "#{version}-all"
    libexec.install "zenio-#{version}-all.jar"
    bin.install "zenio"
  end

  test do
    system "#{bin}/zenio", "init", "GitLab"
  end
end
