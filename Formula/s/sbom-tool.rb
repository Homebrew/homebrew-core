class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "a7ae3295985137b77b13c319bcefad2f750e463d1cde923de0b5df2836eb1176"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83dcd5a909957731cd9bde9ba8f788981c4e43191ef54f03bde77ffdfbed52b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e412a968ace9952722dfd95967747ac7c6340d805281640531ca983630004436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97392a4bf201f45079ff8432f95c39dd9adfc8ab6a73e5628ea50fa1462ae96d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14c529659725982742b81df22864588b73dec8850eda55a8979ec4a23f7d62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc9d96dc0e6b289dbf36865178bb4895a455a95885efd7b784bb7688935d755"
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
