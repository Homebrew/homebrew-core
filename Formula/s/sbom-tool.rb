class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "6c5e59a930b1aa728a38289a5fcd7a513f7cb8858e0c6a35a5909449a887b10f"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79d54bf454dee111a6c12aa3f067c98e61b25a917e985b06f86fc74c9b507754"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b950b45daad39f0ad154e2dda513691181263a92eff263218a61ef82a6c71888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3cd18df46acb5d3e62c0095492cc2acdd2197933cee62e77a8faa32a04505c"
    sha256 cellar: :any_skip_relocation, ventura:        "855a2efae43fa405bd377cfa592567e0f1604b286595729a100ccc91bf20a0a0"
    sha256 cellar: :any_skip_relocation, monterey:       "5ba33bdfcf5ab4448b1f1086bbef5fcaf9c9f3cb5b7c7ca09a5f4df818d34b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9a5796b91e73007dabeacecadee881d0111bc15d82ab294041bf9cdeb2e867"
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
