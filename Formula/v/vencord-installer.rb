class VencordInstaller < Formula
  desc "Installer for Vencord"
  homepage "https://vencord.dev"
  url "https://github.com/Vencord/Installer/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "77e476066cf7d249e43416bc0adbf59f38c32eaee207e72419de706d6ba33fc8"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'vencordinstaller/buildinfo.InstallerGitHash=#{tap.user}' -X 'vencordinstaller/buildinfo.InstallerTag=v#{version}'"
    tags = "static cli"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:)
  end

  test do
    assert_match "Vencord Installer Cli v#{version} (#{tap.user})", shell_output("#{bin}/vencord-installer -version")
    assert_match "ERROR Discord stable not found", shell_output("#{bin}/vencord-installer -install -branch stable", 1)
  end
end
