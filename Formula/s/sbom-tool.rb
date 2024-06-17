class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "2f4f9f624c5bd4881bee920e5c2a8801c23889da9b61935912f28e27c7fc6aaf"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a74e432d437d743783f196da854c1978eeb523cb09f82ca40189fe7d6ac1dc4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d245a508f38f49dbcd3fb7e00e5ebd9d4a4c3e3a9ec6e7fbfe82d4e8d1b46e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8bca177ee182cdb2c110868b32a6d0f19b96b0c1017ec111accf9ac20936d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c189d8a5cdc6612bc40f3896d61c1b2fc8af2619f8cd86a03c133c08dc54fa90"
    sha256 cellar: :any_skip_relocation, ventura:        "bf33692f2d9f549eb6827c05f94119decaa90548d06a992f25f3f099da426e2b"
    sha256 cellar: :any_skip_relocation, monterey:       "72d777eaf070fd70ec865f41b8fbda10efee33428e423fc50564810aa045efa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4336d259bb08ed15dffaa793fb63d26b8bd063342b6daa8d484abe6c2510d9ac"
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
