class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  # NOTE: The last GitHub release no longer builds due to security issues.
  # For now, we track newer git tags which haven't been marked as releases.
  # Upstream seems to have stopped responding to issues since deciding to not
  # accept contributions: https://github.com/microsoft/sbom-tool#contributing
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.11.tar.gz"
  sha256 "2f0c4ad09e7d8cc1faa02dad900683bf3b3d43482de835950a9ce2e697a79107"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc7677e917f6676b5702d1530aab5036b6348d46f2d0ffe8fbc2f36743ef76a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8358a4c362227e3f11612d26c1db7e53c927bb0529a516874c8db4ee2f063214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd0ecd2c0920a0b402391062c5d802bb77136abcbe48b6bb668a19037be64df"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc3f907ee1da54d9f2c29f421dfe66eea8c64f11185af9ee6eb48e23a20ab81a"
    sha256 cellar: :any,                 arm64_linux:   "f7e8740396696242a547a7a7b68fedbac8657707bfc3b67a763fe9a248fbfbe9"
    sha256 cellar: :any,                 x86_64_linux:  "32452307c931f8d9988ac09f3c6b205ecd46b83b0d86b9ab95a3341c190cd8c5"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 8"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 8"

  depends_on "dotnet@8"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@8"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb https://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
