class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "99ccdcba143eacff433c7c0a47d5a5bee1ab7e050b8ee600b3e02656f55cc93f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ee5dac96bebd91fe1253a2b6c267773677890118096a9d291cdc24f31174372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0acf99320e915ccee1511b294dfba95639d79826fefc02b57ea0adcb4c34d82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fcf92e1f1c0ead9cc6867b9fc64e1bb089d6fad2aa4628c44732e6c350ab5bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb12da6615eea0eebc4c9fa282c8f3f54c5537d93ab54ef03c66f3ff57c63ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b6a8d4d149d1dec313a8b9fba5f096f67d7ade1e7f7f363ee580db7a795be9"
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
