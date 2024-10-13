class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "013dbd84214ae9b41918138fc0292570b0819cb9284a860363eb2532dda204e5"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0180cdb70b1aa227c07f460824d360726bc38476904158899795854017a2ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8187fac2b281d8031bbd3d86954f3fc71f5ab236ec08538a34f9752d8a59463b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29bd6d62c85ca6c92d32909b3a9ec9d85ddbe1ea0273535b3dd834e2fb98e52f"
    sha256 cellar: :any_skip_relocation, sonoma:        "27604c0023bba19d5473c6ced252ab3ce2e7e5e40eb64d039e63b5ba06c5a454"
    sha256 cellar: :any_skip_relocation, ventura:       "22d665ec20d1d79556a310d4457cb5222ad3078e957c3d8017824b9b88f07bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31114583c0e2dbc15dd4fe35b5ac88085057fc012e04e9bfe7359eae9dc7f54b"
  end

  depends_on "dotnet"

  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool",
                                       DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
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
