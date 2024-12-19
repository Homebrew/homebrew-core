class Recyclarr < Formula
  desc "Automatically sync TRaSH Guides to your Sonarr and Radarr instances"
  homepage "https://recyclarr.dev"
  version "7.4.0"
  url "https://github.com/recyclarr/recyclarr.git", tag: "v#{version}"
  license "MIT"

  depends_on "dotnet@8" => :build
  # recyclarr has a dependency on git, which according to brew audit is always available

  def install
    args = %W[
      --configuration Release
      --output #{libexec}
      --self-contained true
      -p:PublishSingleFile=true
      -p:EnableCompressionInSingleFile=true
      -p:PublishReadyToRunComposite=true
      -p:TieredCompilation=false
    ]

    system "dotnet", "publish", "src/Recyclarr.Cli", *args
    bin.install_symlink libexec/"recyclarr"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/recyclarr --version")
  end
end
