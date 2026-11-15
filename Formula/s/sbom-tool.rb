class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  # NOTE: The last GitHub release no longer builds due to security issues.
  # For now, we track newer git tags which haven't been marked as releases.
  # Upstream seems to have stopped responding to issues since deciding to not
  # accept contributions: https://github.com/microsoft/sbom-tool#contributing
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.13.tar.gz"
  sha256 "4fba2326473b3cfa40cf6e4ee2dec25d2f7951fdba6a9bcabb217c5ca99d2d0c"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55e1afc312180a210fcd9e11fd2290a324aa664bbfef49a47a51af2e18fcca27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "089eb84af886373eca4c8e5b765772cf851bce5fbc75d0df01dfe62397a6ab14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1dae838b49c03e7dadc2ee1ee0249646ee7e3dd97a259eb0efa31f1b57f6c62e"
    sha256 cellar: :any,                 arm64_linux:       "4b50991c2c6a78a4773912cbc42b32524bf41144d977b7dce27f5c6446dd06e7"
    sha256 cellar: :any,                 x86_64_linux:      "b2228fff1b907bf2e945f9943a8fbb8a5d1c67fcb284a16c10511c70a20decc8"
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
