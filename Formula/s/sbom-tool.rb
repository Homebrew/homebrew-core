class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "8b4c8d9040f085e86c8344261680f0bdc3df7856bc88391c5a67ca1ff7e416f7"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dad2be6739dea0b0ed69fd3001d7b691f261adeeec3ccedfcef388b509c3d82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0137523d8ad99b9280e936722f101abd1098e478038bc347eef1d4e1890bfbab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "216c4eebb81fd868c8f16d67a3a1a90438979907379c582f5445f852ba90f291"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca85a9a41d652147f6fb2f7cac541083270dc881e094712b9e90eed5a2663a35"
    sha256 cellar: :any_skip_relocation, ventura:        "4b66b164410e7c584344e395fff4bd7a6c700c183527e5670b6836154e2521f2"
    sha256 cellar: :any_skip_relocation, monterey:       "ffae5c3d41d2a67fac4d8fb4b4171c8a3cb8ef0ef9c71871f06e705a664e6ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "617fd82d89b8ecb4a04973c38d4281a34679fba1cbbabd6bffca0b6c10f93554"
  end

  depends_on "dotnet"

  uses_from_macos "icu4c" => :test
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
      -nsb http://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
