class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "3e31ffe0d7bfe26ecfc59772b8e828f08ac8c39a3ddfdc0a24d7d603afa7e45b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff8fbdbfb4a321fc72980e047cf8326fa745ab20d22da59152c3239fd9e58e85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d387409a55a1965c920dc52033028049ae4bedeb759b054a4e716074763000"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5022471bef61a6cf96c9172c925baf519ac0349f3a9d1e2ea9ebab8ffed1315d"
    sha256 cellar: :any_skip_relocation, ventura:       "f4d9fc9f31e1bdbacc85656dd6811bb3dc77e7792cf27bd306f534721df57136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a92f21640ecabfe329c5b39570ae95c343eb311471bec87fb63958b7bb5b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c87d83bc21c734cb7cd9355da63ba7b4b592c8996a26629c391b37acdf42615"
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
