class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  # NOTE: The last GitHub release no longer builds due to security issues.
  # For now, we track newer git tags which haven't been marked as releases.
  # Upstream seems to have stopped responding to issues since deciding to not
  # accept contributions: https://github.com/microsoft/sbom-tool#contributing
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.12.tar.gz"
  sha256 "cb1116622aa38e352b02d7c968c3c50944d970edc52acb55e0a3368b2c465888"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16f859cdfae3bd4f7be01e91c7a3b39b12d53b1b67552346908da2e93b38d2ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f228560d736f05482e2191cb1724db63711a31feb34ba75906464b7091bba848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00e262e97e0e16cd5dff88f9e9a9f7716a36b22c9611846235dd0c9c77331b90"
    sha256 cellar: :any,                 arm64_linux:       "fee8e53f638d1c29f81240a56c086a737c7413de7331f90a88aa1ebbb6317464"
    sha256 cellar: :any,                 x86_64_linux:      "d2ce814f79914567d7f170d6fba5382a45374caf165b149b0c71624365e33557"
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
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

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
