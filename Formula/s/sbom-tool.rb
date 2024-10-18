class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "90085ab1f134f83d43767e46d6952be42a62dbb0f5368e293437620a96458867"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd07cf8531b2d6120d052b498dd9e273b131e15f9cce5964996b083ec9b851ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344c264ec814f20dead2e14aeb6888ed483d1003a8e91e4625b88ccc5e57b92d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa834547524901e2f6d4f0e891e48547378da7c722fb93981a8c19004ae284d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "27d9f132d895097aa7454d9e3bc43adca410cab2c7088cbc184cf21174141c7a"
    sha256 cellar: :any_skip_relocation, ventura:       "db0dcb0a4e6b7bfd6c131c9cfbd201403709d20561a2223931e75830aa5d893d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7350a825d6b0e31ff02f6145487765ed899d95d1243f9d91d914b63b3102c59"
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
