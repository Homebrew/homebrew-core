class Zenio < Formula
  desc "CLI Zenio Tool"
  homepage "https://dev.zenio.co"
  url "https://dev.zenio.co/cli/download/zenio-0.8.1.tar"
  sha256 "8838c70497d0d4e99365c32a7a197f90f2d3e67a8b1cab5e5a6ebac4f6d1bc92"

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
