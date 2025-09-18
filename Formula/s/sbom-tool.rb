class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "6c1a34e17ddd1eeff5e0de298cd8cc9cd53e8920cdee572dcff3eaf239e87d3a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fde68cd893c1d3cb1526a083cd110b6b7a720b1cad39a642cf8b3c2997c1b688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e33905365e6a6ec3387638ed0dcd5620c1a5c768c0eb67e109e9132013b1a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86806938235930bda5f4811bffd677490b146bc4c3dff9657f3674a2f380cee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f10017fd6609cbd67a00e8fc9c5d1937b9c9a1313277755e54129dcb2576535"
    sha256 cellar: :any_skip_relocation, ventura:       "5cacbee071959bd3f85ec5fd29bcacd0130c245b4adb5fffe5a3c8c1a411a765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29aea8e9e84b57899f7d4a33578d2e218dbea26768303dfecc05000b816688bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8bd3e748d696baa2abca35b03dea945ff16dc382047364b0ff482fa4138708a"
  end

  depends_on "dotnet@8"

  uses_from_macos "zlib"

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
