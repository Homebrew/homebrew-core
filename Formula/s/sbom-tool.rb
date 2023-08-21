class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6997e195ce2cb0902d913ec23cec0ebb015f90d1ab26c861beaaaadf4f456391"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "ef15a9fc649fcd7119238b34dd611bf861797a3a9102ee83bd511676e7018612"
    sha256 cellar: :any_skip_relocation, monterey:     "ef15a9fc649fcd7119238b34dd611bf861797a3a9102ee83bd511676e7018612"
    sha256 cellar: :any_skip_relocation, big_sur:      "ef15a9fc649fcd7119238b34dd611bf861797a3a9102ee83bd511676e7018612"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7097725fda79fb57dcc71f0073312db48f19fed5b24874313e9efb9b5ff067bb"
  end

  depends_on "dotnet" => :build
  # currently does not support arm build
  # upstream issue, https://github.com/microsoft/sbom-tool/issues/223
  depends_on arch: :x86_64

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    # the architecture is hardcoded to x64 for macOS due to to an issue with
    # the inclusion of dynamic libraries for the self-contained executable, for
    # details see: https://github.com/microsoft/sbom-tool/issues/223#issuecomment-1644578606
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = if OS.mac? || Hardware::CPU.intel?
      "x64"
    else
      Hardware::CPU.arch.to_s
    end

    args = %W[
      --configuration Release
      --output #{buildpath}
      --runtime #{os}-#{arch}
      --self-contained=true
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    bin.install "Microsoft.Sbom.Tool" => "sbom-tool"
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb http://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
