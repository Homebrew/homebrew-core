class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "4a7d858775629148b5a83246a78954489bc1f637c117ba33cca4fb44d826955a"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e29cf57e4c4f097c0331f9ecf1be5cda905be080f36f9d15f09f7073676e714"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89e3e06bfc97e69db21761a5dacbd59e1835cafab840dce56e611342f392dcb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9ea68b2eb82cdf104826ad04f3014dcb30d0547ade66a49165820d017864261"
    sha256 cellar: :any_skip_relocation, sonoma:         "51eafcd21b28fea972d1b2f523bd0badf2b5c806b5f39435c47fb0b7716a9397"
    sha256 cellar: :any_skip_relocation, ventura:        "7359c78b0fa3c881e9dfcb54d08f17aa5d1b51c22e694f2fc9dcdbd7bfefd921"
    sha256 cellar: :any_skip_relocation, monterey:       "f25161cf2102a195a357f3615869036b4b63fb9424627048e5cb97bce2403bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d473611de86422fbf882eb8306a304f13ec240ec3f5e7325ae60530adbd6d534"
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
      -nsb https://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
