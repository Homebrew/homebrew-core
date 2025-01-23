class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "90085ab1f134f83d43767e46d6952be42a62dbb0f5368e293437620a96458867"
  license "MIT"
  revision 1
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf387a8034456bb65d63d4f864ec3b81748652ad39dd38d3d3807d02b437433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c0d07a6e89a1f372531636ca561f2e5af41910ecc5791cf931730503f063795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a77a8352820d51e87c58b88aa7e696a3ab97694866dffb3e8875c8fe208b89"
    sha256 cellar: :any_skip_relocation, ventura:       "844c19d372a7fab9e4c596a4e36c61bf8c42a5d820cc683923d5b24bd6636b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd6bee59cbb61af9efeb983811f7f6e418395efc5bbc2ba3796c118c743f663"
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
