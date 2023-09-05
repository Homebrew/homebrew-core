class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "02baf24d3ab7f4f264cf8f205fb7f03e4e4aacfaace58bb07f0cfafc58ae2b78"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "6f7c90590af038b4eea59f833f61005a8aaf1f30c20fc1b3a4dd526bb3f32b54"
    sha256 cellar: :any_skip_relocation, monterey:     "6f7c90590af038b4eea59f833f61005a8aaf1f30c20fc1b3a4dd526bb3f32b54"
    sha256 cellar: :any_skip_relocation, big_sur:      "6f7c90590af038b4eea59f833f61005a8aaf1f30c20fc1b3a4dd526bb3f32b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "028572f64904918548611554ddeb1e99d36397028c7ccc45770989a3a4f2dc05"
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
